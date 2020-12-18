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
   
   var cancellables: Set<AnyCancellable> = []
   init(translation: Translation) {
      self.translation = translation
      onTranslationChange()
   }
   
   func onTranslationChange() {
      $translation
         .sink(receiveValue: {
            self.books = Bundle.main.decode(file: "books_\($0.abbrev).json")
         })
         .store(in: &cancellables)
   }
   
   static func preview(_ translation: Translation) -> BibleController {
      BibleController(translation: translation)
   }
}
