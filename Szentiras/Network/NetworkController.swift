//
//  NetworkController.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 26..
//

import Foundation
import Combine
import TimelaneCombine

class NetworkController: ObservableObject {
   
   static var instance = NetworkController()
   private init() {}
   
   func fetchChapter(translation: Translation, book: Book, chapter: Int) -> AnyPublisher<SearchResult, BibleError> {
      let bookAbbrev = book.abbrev.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
      let link = "https://szentiras.hu/api/idezet/\(bookAbbrev)\(chapter)/\(translation.abbrev)"
      guard let url = URL(string: link) else {
         return Fail(error: BibleError.badURL).eraseToAnyPublisher()
      }
      return URLSession.shared.dataTaskPublisher(for: url)
         .tryMap({data, response -> Data in
            if data.isEmpty {
               throw BibleError.dataCorrupted
            }
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
               throw BibleError.badServerResponse
            }
            return data
         })
         .decode(type: SearchResult.self, decoder: JSONDecoder())
         .mapError({error -> BibleError in
            switch error {
            case URLError.badServerResponse:
               return BibleError.badServerResponse
            case URLError.badURL:
               return BibleError.badURL
            case URLError.cannotFindHost:
               return BibleError.cannotFindHost
            case URLError.cannotLoadFromNetwork:
               return BibleError.cannotLoadFromNetwork
            case URLError.cannotParseResponse:
               return BibleError.cannotParseResponse
            case URLError.internationalRoamingOff:
               return BibleError.internationalRoamingOff
            case URLError.networkConnectionLost:
               return BibleError.networkConnectionLost
            case URLError.notConnectedToInternet:
               return BibleError.notConnectedToInternet
            case URLError.unsupportedURL:
               return BibleError.unsupportedURL               
            case DecodingError.dataCorrupted:
               return BibleError.dataCorrupted
            case DecodingError.keyNotFound(let key, _):
               return BibleError.keyNotFound(key)
            case DecodingError.typeMismatch(let type, _):
               return BibleError.typeMismatch(type)
            case DecodingError.valueNotFound(let value, _):
               return BibleError.valueNotFound(value)
            default:
               return BibleError.unknown
            }
         })         
         .eraseToAnyPublisher()
   }
}
