//
//  BibleError.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 26..
//

import Foundation

enum BibleError: Error, CustomStringConvertible, Equatable {
   static func == (lhs: BibleError, rhs: BibleError) -> Bool {
      lhs.description == rhs.description
   }
   
   case badServerResponse, badURL, cannotFindHost, cannotLoadFromNetwork, cannotParseResponse,
        internationalRoamingOff, networkConnectionLost, notConnectedToInternet, unsupportedURL,
        dataCorrupted, keyNotFound(CodingKey), valueNotFound(Any), typeMismatch(Any), unknown
   
   var description: String {
      switch self {
      case .badServerResponse:
         return "Szerver válasz hibás"
      case .badURL:
         return "URL hibás"
      case .cannotFindHost:
         return "Hoszt nem található"
      case .cannotLoadFromNetwork:
         return "Letöltési hiba"
      case .cannotParseResponse:
         return "Formázási hiba"
      case .internationalRoamingOff:
         return "Roaming letiltva"
      case .networkConnectionLost:
         return "Hálózati kapcsolat megszakadt"
      case .notConnectedToInternet:
         return "Nincs hálózati kapcsolat"
      case .unsupportedURL:
         return "URL nem támogatott"
      case .dataCorrupted:
         return "Hibás adatállomány"
      case .keyNotFound(let key):
         return "A kulcs nem létezik: '\(key.stringValue)'"
      case .valueNotFound(let value):
         return "Az érték nem létezik: \(value)"
      case .typeMismatch(let value):
         return "Eltérő típusok: \(value)"
      case .unknown:
         return "Ismeretlen hiba"
      }
   }  
}
