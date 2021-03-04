//
//  BookmarkModel.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 01. 22..
//

import Foundation

extension Bookmark: Comparable {
   public static func < (lhs: Bookmark, rhs: Bookmark) -> Bool {
      lhs.order < rhs.order
   }
   
   var color: String {
      get { color_ ?? "" }
      set {
         color_ = newValue
      }
   }
   var gepi: String {
      get { gepi_ ?? "" }
      set {
         gepi_ = newValue
      }
   }
   var order: Int {
      get { Int(order_) }
      set {
         order_ = Int16(newValue)
      }
   }
   var szep: String {
      get { szep_ ?? "" }
      set {
         szep_ = newValue
      }
   }
   var szoveg: String {
      get { szoveg_ ?? "" }
      set {
         szoveg_ = newValue
      }
   }
   var translation: String {
      get { translation_ ?? "" }
      set {
         translation_ = newValue
      }
   }
}

extension Bookmark {
    func book(translation: Translation) -> Book? {
        let books = Book.all(translation: translation.abbrev)
        let bookGepi = String(self.gepi.prefix(3))
        return books.first(where: {String($0.number) == bookGepi})
    }
    
    func chapter() -> Int? {
        let gepi = self.gepi.dropFirst(3)
        return Int(gepi.prefix(3))
    }
}
