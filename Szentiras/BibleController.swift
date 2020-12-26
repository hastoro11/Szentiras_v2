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
   @Published var translation: Translation = Translation()
   @Published var activeBook: Book
   @Published var activeChapter: Int = 1
   var cancellables: Set<AnyCancellable> = []
   
   // MARK: - Init
   init(translation: Translation) {
      self.translation = Translation.defaultTranslation
      activeBook = Book.defaultBook(for: translation)
      onTranslationChange()
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
      var trs = Translation.all().map({ trans -> ActionSheet.Button in
         ActionSheet.Button.default(Text(trans.name), action: {
            self.changeTranslation(to: trans)
         })
      })
      trs.append(ActionSheet.Button.cancel(Text("Mégsem")))
      return trs
   }
   
   func changeTranslation(to translation: Translation) {
      self.translation = translation
      UserDefaults.setTranslation(abbrev: translation.abbrev)
   }
   
   //--------------------------------
   // Preview
   //--------------------------------
   static func preview(_ translation: Translation) -> BibleController {
      BibleController(translation: translation)
   }
}
