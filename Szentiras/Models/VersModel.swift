//
//  VersModel.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 27..
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchResult = try? newJSONDecoder().decode(SearchResult.self, from: jsonData)

import Foundation

//--------------------------------
// SearchResult
//--------------------------------
struct SearchResult: Codable {
    let keres: Keres
    let valasz: Valasz
}

extension SearchResult: Comparable {
   var chapterNumber: Int {
      let hivatkozas = self.keres.hivatkozas
      let chapterString = hivatkozas.split(separator: " ")[1]
      return Int(chapterString) ?? 0
   }
   
   static func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
      lhs.chapterNumber < rhs.chapterNumber
   }
   
   static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
      lhs.chapterNumber == rhs.chapterNumber
   }
}

// MARK: - Keres
struct Keres: Codable {
    let feladat, hivatkozas, forma: String
}

// MARK: - Valasz
struct Valasz: Codable {
    let verses: [Vers]
    let forditas: Forditas
   
   enum CodingKeys: String, CodingKey {
      case forditas
      case verses = "versek"
   }
}

// MARK: - Forditas
struct Forditas: Codable {
    let nev, rov: String
}

//--------------------------------
// Vers
//--------------------------------
struct Vers: Codable, Identifiable {
   var id: Int { hely.gepi }
    let szoveg: String?
    let hely: Hely
}

extension Vers {
   var index: String {
      String(hely.szep.split(separator: ",").last ?? "")
   }
}

extension Vers {
   static var mockData: [Vers] {
      let url = Bundle.main.url(forResource: "searchResult_mock", withExtension: "json")!
      guard let data = try? Data(contentsOf: url) else {
         fatalError("Error reading searchResult data file")         
      }
      do {
         let result = try JSONDecoder().decode(SearchResult.self, from: data)
         return result.valasz.verses
      } catch DecodingError.keyNotFound(let key, _) {
         print("Key not found: \(key.stringValue)")
      } catch {
         print("Parsing error")
      }
      return []
   }
}

// MARK: - Hely
struct Hely: Codable {
    let gepi: Int
    let szep: String
}
