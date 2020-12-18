//
//  BookModel.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import Foundation

struct Book: Decodable {
   var abbrev: String
   var name: String
   var number: Int
}

extension Book {
   static func all(translation: String) -> [Book] {
      Bundle.main.decode(file: "books_\(translation)")
   }
}
