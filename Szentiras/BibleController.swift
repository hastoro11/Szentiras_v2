//
//  BibleController.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import SwiftUI
import Combine

class BibleController: ObservableObject {
   @Published var books: [Book] = []
   @Published var translation: Translation
   @Published var activeBook: Book
   @Published var activeChapter: Int = 1
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
   }
   
   func chapterViewOnDismiss() {      
      activeChapter = min(activeChapter, activeBook.numberOfChapters)
   }

   //--------------------------------
   // Translation
   //--------------------------------
   private func onTranslationChange() {
      $translation
         .sink(receiveValue: {
            self.books = Bundle.main.decode(file: "books_\($0.abbrev).json")
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
