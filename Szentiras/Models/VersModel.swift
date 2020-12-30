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

// MARK: - SearchResult
struct SearchResult: Codable {
    let keres: Keres
    let valasz: Valasz
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

// MARK: - Versek
struct Vers: Codable, Identifiable {
   var id: Int { hely.gepi }
    let szoveg: String
    let hely: Hely
}

extension Vers {
   var index: String {
      String(hely.szep.split(separator: ",").last ?? "")
   }
}

// MARK: - Hely
struct Hely: Codable {
    let gepi: Int
    let szep: String
}
