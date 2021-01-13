//
//  SzentirasExtensionTests.swift
//  SzentirasExtensionTests
//
//  Created by Gabor Sornyei on 2021. 01. 09..
//

import XCTest

class SzentirasExtensionTests: XCTestCase {

   func test_String() {
      let strings = [
         "This is a test<b>",
         "This is a test<>",
         "<>This is a test<bb>",
         "This<_> is a test<b>",
         "This is a test<b>",
         "<>This is a test"
      ]
      
      for str in strings {
         print(str, str.strippedHTMLElements.count)
         XCTAssertEqual("This is a test", str.strippedHTMLElements)
      }
   }
   
   func test_Bundle_decode() {
      struct TTranslation: Decodable, Identifiable, Hashable {
         var abbrev: String = "RUF"
         var name: String = "Magyar Bibliatársulat újfordítású Bibliája (2014)"
         var short: String = "Új fordítás"
         var id: Int = 6
      }
      
      let bundle = Bundle(for: SzentirasExtensionTests.self)
      
      do {
         let url = try XCTUnwrap(
            bundle.url(forResource: "translations", withExtension: "json")
         )
         let data = try XCTUnwrap(
            try Data(contentsOf: url)
         )
         let translations = try JSONDecoder().decode([TTranslation].self, from: data)
         XCTAssertFalse(translations.isEmpty)
         XCTAssertEqual("RUF", translations.reversed()[0].abbrev)
      } catch {}
   }
   
   func test_Bundle_decode_fail() {
      struct Translation1: Decodable, Identifiable, Hashable {
         var abbre: String = "RUF"
         var name: String = "Magyar Bibliatársulat újfordítású Bibliája (2014)"
         var short: String = "Új fordítás"
         var id: Int = 6
      }
      struct Translation2: Decodable, Identifiable, Hashable {
         var abbrev: String = "RUF"
         var nam: String = "Magyar Bibliatársulat újfordítású Bibliája (2014)"
         var short: String = "Új fordítás"
         var id: Int = 6
      }
      struct Translation3: Decodable, Identifiable, Hashable {
         var abbrev: String = "RUF"
         var name: String = "Magyar Bibliatársulat újfordítású Bibliája (2014)"
         var shor: String = "Új fordítás"
         var id: Int = 6
      }
      struct Translation4: Decodable, Hashable {
         var abbre: String = "RUF"
         var name: String = "Magyar Bibliatársulat újfordítású Bibliája (2014)"
         var short: String = "Új fordítás"
         var id1: Int = 6
      }
      
      let bundle = Bundle(for: SzentirasExtensionTests.self)
      
      do {
         let url = try XCTUnwrap(
            bundle.url(forResource: "translations", withExtension: "json")
         )
         let data = try XCTUnwrap(
            try Data(contentsOf: url)
         )
         XCTAssertThrowsError(try JSONDecoder().decode([Translation1].self, from: data), "") { (error) in
            guard case DecodingError.keyNotFound = error else {
               XCTFail("Error")
               return
            }
         }
         XCTAssertThrowsError(try JSONDecoder().decode([Translation2].self, from: data), "") { (error) in
            guard case DecodingError.keyNotFound = error else {
               XCTFail("Error")
               return
            }
         }
         XCTAssertThrowsError(try JSONDecoder().decode([Translation3].self, from: data), "") { (error) in
            guard case DecodingError.keyNotFound = error else {
               XCTFail("Error")
               return
            }
         }
         XCTAssertThrowsError(try JSONDecoder().decode([Translation4].self, from: data), "") { (error) in
            guard case DecodingError.keyNotFound = error else {
               XCTFail("Error")
               return
            }
         }
         
      } catch {}
   }
}
