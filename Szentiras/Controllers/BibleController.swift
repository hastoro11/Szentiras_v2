//
//  BibleController.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import SwiftUI
import Combine

class BibleController: ObservableObject {   
    @Published var selectedTab: Int = 1
    
    @Published var books: [Book] = []
    @Published var translation: Translation
    @Published var activeBook: Book
    @Published var activeChapter: Int = 1
    @Published var versesInBook: [[Vers]] = []
    
    @Published var isLoading: Bool = false
    @Published var error: BibleError?
    
    var cancellables: Set<AnyCancellable> = []
    var savedDefault: SavedDefault
    
    var networkController: NetworkProtocol
    
    //--------------------------------
    // Init
    //--------------------------------
    init(savedDefault: SavedDefault, networkController: NetworkProtocol) {
        self.savedDefault = savedDefault
        self.translation = Translation.get(abbrev: savedDefault.translation)
        let allBooks = Book.all(translation: savedDefault.translation)
        self.books = allBooks
        self.activeBook = allBooks.first(where: {$0.number == savedDefault.book}) ?? allBooks[0]
        self.activeChapter = savedDefault.chapter
        self.networkController = networkController
        onTranslationChange()
        onBookChange()
    }
    
    //--------------------------------
    // MARK: - Combine listeners
    //--------------------------------
    private func onTranslationChange() {
        // Changes list of books
        $translation
            .sink(receiveValue: { [self] transl in
                self.books = Bundle.main.decode(file: "books_\(transl.abbrev).json")
                activeBook = books.first(where: {activeBook.id == $0.id}) ?? activeBook
            })
            .store(in: &cancellables)
        
        // Fetches books
        $translation
            .sink(receiveValue: { [self] transl in
                fetchBook(translation: transl, book: activeBook)
            })
            .store(in: &cancellables)
    }
    
    private func onBookChange() {
        // Fetches book
        $activeBook
            .sink(receiveValue: {[self] book in
                fetchBook(translation: translation, book: book)
            })
            .store(in: &cancellables)
    }
    
    //--------------------------------
    // MARK: - Fetch book
    //--------------------------------
    func fetchBook() {
        self.fetchBook(translation: translation, book: activeBook)
    }
    
    private func fetchBook(translation: Translation, book: Book) {
        let cacheKey = "\(translation.abbrev)/\(book.number)"
        isLoading = true
        if CacheManager.instance.isBookSaved(key: cacheKey) {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [unowned self] in
                versesInBook = CacheManager.instance.getVerses(key: cacheKey)
                isLoading = false
            }
        } else {
            NetworkController.instance.fetchBook(translation: translation, book: book)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: {[self] completion in
                    switch completion {
                        case .failure(let error):
                            self.error = error
                            self.versesInBook = []
                        case .finished:
                            break
                    }
                    isLoading = false
                }, receiveValue: {[self] results in
                    let foundVersesInBook = results.sorted().map({$0.valasz.verses})
                    versesInBook = foundVersesInBook
                    CacheManager.instance.addBook(key: cacheKey, verses: foundVersesInBook)
                })
                .store(in: &cancellables)
        }
    }
    
    //--------------------------------
    // MARK: - Jump to bookmark
    //--------------------------------
    func jumpToVers(bookmark: Bookmark) {
        guard let book = bookmark.book(translation: self.translation), let chapter = bookmark.chapter() else { return }
        self.activeBook = book
        self.activeChapter = chapter
        self.selectedTab = 1

    }
    
    //--------------------------------
    // MARK: - Translation sheet helpers
    //--------------------------------
    var translationButtons: [ActionSheet.Button] {
        var translations = Translation.all()
        if activeBook.isCatholic() {
            translations.remove(atOffsets: IndexSet(integersIn: 0...1))
        }
        var trs = translations.map({ trans -> ActionSheet.Button in
            ActionSheet.Button.default(Text(trans.short), action: {
                self.changeTranslation(to: trans)
            })
        })
        trs.append(ActionSheet.Button.cancel(Text("Mégsem")))
        return trs
    }
    
    func changeTranslation(to translation: Translation) {
        self.translation = translation
    }
    
    //--------------------------------
    // MARK: - Paging
    //--------------------------------
    enum PagingDirection {
        case previous, next
    }
    
    func paging(_ direction: PagingDirection) {
        if direction == .previous {
            activeChapter = activeChapter == 1 ? 1 : activeChapter-1
        } else {
            activeChapter = activeChapter == activeBook.numberOfChapters ? activeChapter : activeChapter+1
        }
    }
    
    var isFirst: Bool {
        activeChapter == 1
    }
    
    var isLast: Bool {
        activeChapter == activeBook.numberOfChapters
    }
    
    //--------------------------------
    // MARK: - Preview
    //--------------------------------
    static func preview(_ savedDefault: SavedDefault) -> BibleController {
        BibleController(savedDefault: savedDefault, networkController: NetworkController.instance)
    }
}
