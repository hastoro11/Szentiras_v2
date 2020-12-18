//
//  UserDefaults+Extension.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import Foundation

extension UserDefaults {
   enum AppKey: String {
      case translationKey
   }
   
   static func setTranslation(abbrev: String) {
      Self.standard.setValue(abbrev, forKey: UserDefaults.AppKey.translationKey.rawValue)
   }
   
   static func getTranslation() -> Translation {
      let abbrev = Self.standard.string(forKey: UserDefaults.AppKey.translationKey.rawValue) ?? "RUF"
      return Translation.get(abbrev: abbrev)
   }
}
