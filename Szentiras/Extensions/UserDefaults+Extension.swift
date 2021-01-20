//
//  UserDefaults+Extension.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import Foundation

struct SavedDefault: Codable {
   var translation: String = "RUF"
   var book: Int = 202
   var chapter = 1
}

extension UserDefaults {
   static let saveKey = "saveKey"
   
   static func setSavedData(_ savedDefault: SavedDefault, key: String = "saveKey") {
      if let data = try? JSONEncoder().encode(savedDefault) {
         Self.standard.setValue(data, forKey: key)
      }
   }
   
   static func getSavedData(key: String = "saveKey") -> SavedDefault {
      if let data = Self.standard.object(forKey: key) as? Data,
         let savedDefault = try? JSONDecoder().decode(SavedDefault.self, from: data) {
         return savedDefault
      }
      return SavedDefault()
   }
}
