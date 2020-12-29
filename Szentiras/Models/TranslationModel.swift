//
//  TranslationModel.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import Foundation

struct Translation: Decodable, Identifiable, Hashable {
   var abbrev: String = "RUF"
   var name: String = "Magyar Bibliatársulat újfordítású Bibliája (2014)"
   var short: String = "Új fordítás"
   var id: Int = 6
}

extension Translation {
   static func all() -> [Translation] {
      return Bundle.main.decode(file: "translations.json").reversed()
   }

   static func get(abbrev: String) -> Translation {
      Self.all().first(where: {$0.abbrev == abbrev}) ?? Translation()
   }   
}
