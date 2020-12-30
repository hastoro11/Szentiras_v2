//
//  BibleController.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import SwiftUI
import Combine

class BibleController: ObservableObject {
   @Published var selectedTab: Int = 0
   
   @Published var books: [Book] = []
   @Published var translation: Translation
   @Published var activeBook: Book
   @Published var activeChapter: Int = 1
   @Published var verses: [Vers] = []
   @Published var isLoading: Bool = false
   @Published var error: BibleError?
   
   var cancellables: Set<AnyCancellable> = []
   var savedDefault: SavedDefault
   
   // MARK: - Init
   init(savedDefault: SavedDefault) {
      self.savedDefault = savedDefault
      self.translation = Translation.get(abbrev: savedDefault.translation)
      let allBooks = Book.all(translation: savedDefault.translation)
      self.books = allBooks
      self.activeBook = allBooks.first(where: {$0.number == savedDefault.book}) ?? allBooks[0]
      self.activeChapter = savedDefault.chapter
      onTranslationChange()
      onChapterSelect()
   }
   
   //-----------------------------------------------
   // Fetch chapter from network on chapterselection
   //-----------------------------------------------
   func onChapterSelect() {
      $activeChapter
         .handleEvents(receiveOutput: {[self] _ in
            isLoading = true
         })
         .map({[self] chapter in
            NetworkController.instance.fetchChapter(translation: translation, book: activeBook, chapter: chapter)
         })
         .switchToLatest()
         .receive(on: RunLoop.main)
         .sink(receiveCompletion: {[self] completion in
            isLoading = false
            switch completion {
            case .failure(let err):
               print("Error in completion: \(err.description)")
               error = err
            case .finished:
               break
            }
         }, receiveValue: {verses in
            print(verses[0])
            self.verses = verses
         })
         .store(in: &cancellables)
   }
   
   //--------------------------------
   // Helpers
   //--------------------------------
   func chapterViewOnDismiss() {      
      activeChapter = min(activeChapter, activeBook.numberOfChapters)
   }

   //--------------------------------
   // Translation
   //--------------------------------
   private func onTranslationChange() {
      $translation
         .sink(receiveValue: { [self] transl in
            self.books = Bundle.main.decode(file: "books_\(transl.abbrev).json")
            activeBook = books.first(where: {activeBook.id == $0.id}) ?? activeBook
         })
         .store(in: &cancellables)
      
      $translation
         .handleEvents(receiveOutput: {[self] _ in
            isLoading = true
         })
         .map({[self] transl in
            NetworkController.instance.fetchChapter(translation: transl, book: activeBook, chapter: activeChapter)
         })
         .switchToLatest()
         .receive(on: RunLoop.main)
         .sink(receiveCompletion: {[self] completion in
            isLoading = false
            switch completion {
            case .failure(let err):
               print("Error in completion: \(err.description)")
               error = err
            case .finished:
               break
            }
         }, receiveValue: {verses in
            print(verses[0])
            self.verses = verses
         })
         .store(in: &cancellables)
   }
   
   var translationButtons: [ActionSheet.Button] {
      var translations = Translation.all()
      if activeBook.isCatholic() {
         translations.remove(atOffsets: IndexSet(integersIn: 0...1))
      }
      var trs = translations.map({ trans -> ActionSheet.Button in
         ActionSheet.Button.default(Text(trans.name), action: {
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
   // Preview
   //--------------------------------
   static func preview(_ savedDefault: SavedDefault) -> BibleController {
      BibleController(savedDefault: savedDefault)
   }
}
