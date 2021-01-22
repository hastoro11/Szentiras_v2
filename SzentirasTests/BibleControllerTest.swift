//
//  BibleControllerTest.swift
//  SzentirasTests
//
//  Created by Gabor Sornyei on 2021. 01. 20..
//

import XCTest
@testable import Szentiras

class BibleControllerTest: XCTestCase {

   var bibleController: BibleController!
   
   override func setUp() {
      bibleController = BibleController(savedDefault: SavedDefault(), networkController: MockNetworkController())
   }
   
   func test_activeBookChapterTranslation() {
      XCTAssertEqual("RUF", bibleController.translation.abbrev)
      XCTAssertEqual(202, bibleController.activeBook.number)
      XCTAssertEqual(1, bibleController.activeChapter)
      bibleController.activeBook = Book(abbrev: "Tit", name: "", number: 1)
      XCTAssertEqual("Tit", bibleController.activeBook.abbrev)
      
   }

}
