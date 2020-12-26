//
//  BookModel.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import Foundation

struct Book: Decodable, Identifiable {
   var id: Int { number }
   var abbrev: String
   var name: String
   var number: Int
}

extension Book {
   static func all(translation: String) -> [Book] {
      Bundle.main.decode(file: "books_\(translation).json")
   }
   
   static func defaultBook(for translation: Translation) -> Book {
      all(translation: translation.abbrev)[0]
   }
   
   var numberOfChapters: Int {
      Self.numberOfChaptersInBookByNumber[self.number] ?? 1
   }
}

extension Book {
   static var numberOfChaptersInBookByNumber = [
      101: 50,
      102: 40,
      103: 27,
      104: 36,
      105: 34,
      106: 24,
      107: 21,
      108: 4,
      109: 31,
      110: 24,
      111: 22,
      112: 25,
      113: 29,
      114: 36,
      115: 10,
      116: 13,
      117: 14,
      118: 16,
      119: 10,
      120: 42,
      121: 150,
      122: 31,
      123: 12,
      124: 8,
      125: 19,
      126: 51,
      127: 66,
      128: 52,
      129: 5,
      130: 6,
      131: 48,
      132: 12,
      133: 14,
      134: 4,
      135: 9,
      136: 1,
      137: 4,
      138: 7,
      139: 3,
      140: 3,
      141: 3,
      142: 2,
      143: 14,
      144: 3,
      145: 16,
      146: 15,
      201: 28,
      202: 16,
      203: 24,
      204: 21,
      205: 28,
      206: 16,
      207: 16,
      208: 13,
      209: 6,
      210: 6,
      211: 4,
      212: 4,
      213: 5,
      214: 5,
      215: 6,
      216: 4,
      217: 3,
      218: 1,
      219: 13,
      220: 5,
      221: 5,
      222: 3,
      223: 5,
      224: 1,
      225: 1,
      226: 1,
      227: 22

   ]
}
