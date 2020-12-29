//
//  NetworkController.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 26..
//

import Foundation
import Combine

class NetworkController: ObservableObject {
   
   func fetchChapter(translation: Translation, book: Book, chapter: Int) -> AnyPublisher<[Vers], BibleError> {
      let link = "https://szentiras.hu/api/idezet/\(book.abbrev)\(chapter)/\(translation.abbrev)"
      guard let url = URL(string: link) else {
         return Fail(error: BibleError("Hiba a kalkulált linkben")).eraseToAnyPublisher()
      }
      return URLSession.shared.dataTaskPublisher(for: url)
         .tryMap({data, response -> Data in
            if data.isEmpty {
               throw BibleError("Adatállomány hibás")
            }
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
               throw BibleError("HTTP hiba")
            }
            return data
         })
         .decode(type: SearchResult.self, decoder: JSONDecoder())
         .mapError({error in
            switch error {
            case URLError.badServerResponse:
               return BibleError("Szerver válasz hibás")
            case URLError.badURL:
               return BibleError("URL hibás")
            case URLError.cannotFindHost:
               return BibleError("Hoszt nem található")
            case URLError.cannotLoadFromNetwork:
               return BibleError("Letöltési hiba")
            case URLError.cannotParseResponse:
               return BibleError("Formázási hiba")
            case URLError.internationalRoamingOff:
               return BibleError("Roaming letiltva")
            case URLError.networkConnectionLost:
               return BibleError("Hálózati kapcsolat megszakadt")
            case URLError.notConnectedToInternet:
               return BibleError("Nincs hálózati kapcsolat")
            case URLError.unsupportedURL:
               return BibleError("URL nem támogatott")
            case DecodingError.dataCorrupted(let error):
               return BibleError("Hibás adatállomány: \(error.debugDescription)")
            case DecodingError.keyNotFound(let key, let context):
               return BibleError("A kulcs nem létezik: '\(key.stringValue)', \(context.debugDescription)")
            case DecodingError.typeMismatch(let type, let context):
               return BibleError("Eltérő típusok: \(type), \(context.debugDescription)")
            case DecodingError.valueNotFound(let value, let context):
               return BibleError("Az érték nem létezik: \(value), \(context.debugDescription)")
            default:
               return BibleError("Ismeretlen hiba")
            }
         })
         .map({
            return $0.valasz.verses
         })
         .eraseToAnyPublisher()
   }
   
   func fetch<T: Decodable>(_ urlString: String) -> AnyPublisher<T, BibleError> {
      guard let url = URL(string: urlString) else {
         fatalError("A megadott link hibás")
      }
      
      return URLSession.shared.dataTaskPublisher(for: url)
         .tryMap({data, response -> Data in
            if data.isEmpty {
               throw BibleError("Adatállomány hibás")
            }
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
               throw BibleError("HTTP hiba")
            }
            return data
         })
         .decode(type: T.self, decoder: JSONDecoder())
         .mapError({error in
            switch error {
            case URLError.badServerResponse:
               return BibleError("Szerver válasz hibás")
            case URLError.badURL:
               return BibleError("URL hibás")
            case URLError.cannotFindHost:
               return BibleError("Hoszt nem található")
            case URLError.cannotLoadFromNetwork:
               return BibleError("Letöltési hiba")
            case URLError.cannotParseResponse:
               return BibleError("Formázási hiba")
            case URLError.internationalRoamingOff:
               return BibleError("Roaming letiltva")
            case URLError.networkConnectionLost:
               return BibleError("Hálózati kapcsolat megszakadt")
            case URLError.notConnectedToInternet:
               return BibleError("Nincs hálózati kapcsolat")
            case URLError.unsupportedURL:
               return BibleError("URL nem támogatott")
            case DecodingError.dataCorrupted(let error):
               return BibleError("Hibás adatállomány: \(error.debugDescription)")
            case DecodingError.keyNotFound(let key, let context):
               return BibleError("A kulcs nem létezik: '\(key.stringValue)', \(context.debugDescription)")
            case DecodingError.typeMismatch(let type, let context):
               return BibleError("Eltérő típusok: \(type), \(context.debugDescription)")
            case DecodingError.valueNotFound(let value, let context):
               return BibleError("Az érték nem létezik: \(value), \(context.debugDescription)")
            default:
               return BibleError("Ismeretlen hiba")
            }
         })
         .eraseToAnyPublisher()
   }
}
