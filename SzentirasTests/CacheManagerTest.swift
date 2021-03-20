//
//  CacheManagerTest.swift
//  SzentirasTests
//
//  Created by Gabor Sornyei on 2021. 03. 20..
//

import XCTest
@testable import Szentiras

class CacheManagerTest: XCTestCase {
    
    var cacheManager: CacheManager!

    override func setUp() {
        cacheManager = CacheManager.instance
    }

    func testCacheManagerSetup() {
        XCTAssertNotNil(cacheManager)
        XCTAssertEqual(cacheManager.results, [:])
        let mockKey = "key"
        XCTAssertEqual(cacheManager.getVerses(key: mockKey), [[]])
    }
    
    func testCacheManagerFunctions() {
        let translations = ["RUF", "KG", "KNB", "SZIT"]
        let books = [101, 102, 103, 104, 105, 201, 202, 203, 204, 205]
        let verses = [[Vers(szoveg: "szoveg", hely: Hely(gepi: 1, szep: "szep"))]]
        for _ in 0..<100 {
            let cacheKey = "\(translations.randomElement() ?? "RUF")/\(books.randomElement() ?? 101)"
            if cacheManager.isBookSaved(key: cacheKey) {
                XCTAssertEqual(cacheManager.getVerses(key: cacheKey), verses)
            } else {
                XCTAssertEqual(cacheManager.getVerses(key: cacheKey), [[]])
                cacheManager.addBook(key: cacheKey, verses: verses)
                XCTAssertEqual(cacheManager.getVerses(key: cacheKey), verses)
            }
        }
    }
}
