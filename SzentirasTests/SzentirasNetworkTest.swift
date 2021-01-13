//
//  SzentirasNetworkTest.swift
//  SzentirasTests
//
//  Created by Gabor Sornyei on 2021. 01. 10..
//

import XCTest
import Combine
@testable import Szentiras

class SzentirasNetworkTest: XCTestCase {
   var controller: NetworkController!
   var cancellables: Set<AnyCancellable>!
   
   override func setUp() {
      controller = NetworkController.instance
      cancellables = []
   }
   
   func test_WrongTranslation() {
      let book = Book(abbrev: "Mk", name: "", number: 1)
      let translations = [
         Translation(abbrev: "123", name: "", short: "", id: 0),
         Translation(abbrev: "aa", name: "", short: "", id: 0)
      ]
      let expectations = [
         expectation(description: "Passes on translation #1"),
         expectation(description: "Passes on translation #2")
      ]
      for (index, translation) in translations.enumerated() {
         controller.fetchChapter(translation: translation, book: book, chapter: 1)
            .sink(receiveCompletion: {compl in
               guard case let .failure(error) = compl else {
                  XCTFail("Should fail")
                  return
               }
               XCTAssertEqual(error, BibleError.badURL)
               expectations[index].fulfill()
            }, receiveValue: {_ in
               
            })
            .store(in: &cancellables)
      }
      
      waitForExpectations(timeout: 10, handler: nil)
   }
   
   func test_RightTranslation() {
      let book = Book(abbrev: "Mk", name: "", number: 1)
      let translations = [
         Translation(abbrev: "RUF", name: "", short: "", id: 0),
         Translation(abbrev: "KNB", name: "", short: "", id: 0),
         Translation(abbrev: "KG", name: "", short: "", id: 0),
         Translation(abbrev: "SZIT", name: "", short: "", id: 0),
         Translation(abbrev: "", name: "", short: "", id: 0)
      ]
      let expectations = [
         expectation(description: "Passes on translation #1"),
         expectation(description: "Passes on translation #2"),
         expectation(description: "Passes on translation #3"),
         expectation(description: "Passes on translation #4"),
         expectation(description: "Passes on translation #5")
      ]
      for (index, translation) in translations.enumerated() {
         controller.fetchChapter(translation: translation, book: book, chapter: 1)
            .sink(receiveCompletion: {compl in
               guard case .finished = compl else {
                  XCTFail("Not finished as expected")
                  return
               }
               expectations[index].fulfill()
            }, receiveValue: {result in
               XCTAssertFalse(result.valasz.verses.isEmpty)
            })
            .store(in: &cancellables)
      }
      
      waitForExpectations(timeout: 10, handler: nil)
   }
   
   func test_WrongBook() {
      let expectations = [
         expectation(description: "Failed on wrong book #1"),
         expectation(description: "Failed on wrong book #2"),
         expectation(description: "Failed on wrong book #3"),
         expectation(description: "Failed on wrong book #4"),
         expectation(description: "Failed on wrong book #5")
      ]
      let testData = [
         (Book(abbrev: "garbage", name: "", number: 1), chapter: 1),
         (Book(abbrev: "garbage", name: "", number: 1), chapter: 0),
         (Book(abbrev: "garbage", name: "", number: 1), chapter: 145),
         (Book(abbrev: "Mk", name: "", number: 1), chapter: 0),
         (Book(abbrev: "Mk", name: "", number: 1), chapter: 123)
      ]
      
      for (index, data) in testData.enumerated() {
         controller.fetchChapter(translation: Translation(), book: data.0, chapter: data.1)
            .sink(receiveCompletion: {compl in
               guard case let .failure(error) = compl else {
                  XCTFail("Should fail #\(index+1)")
                  return
               }
               XCTAssertEqual(error, BibleError.badURL)
               expectations[index].fulfill()
            }, receiveValue: {_ in
               
            })
            .store(in: &cancellables)
      }
         
      waitForExpectations(timeout: 10, handler: nil)
   }
   
   func test_RightBook_GetAllChapterstow() {
      let translation = Translation()
      let books = [
         Book(abbrev: "1Móz", name: "", number: 101),
         Book(abbrev: "5Móz", name: "", number: 105),
         Book(abbrev: "Mal", name: "", number: 144),
         Book(abbrev: "Mt", name: "", number: 201),
         Book(abbrev: "Gal", name: "", number: 209),
         Book(abbrev: "Jel", name: "", number: 227)
      ]
      
      let expectations = [
         expectation(description: "Passes on 1Móz"),
         expectation(description: "Passes on 5Móz"),
         expectation(description: "Passes on Mal"),
         expectation(description: "Passes on Mt"),
         expectation(description: "Passes on Gal"),
         expectation(description: "Passes on Jel")
      ]
      
      for (index, book) in books.enumerated() {
         controller.fetchBook(translation: translation, book: book)
            .sink(receiveCompletion: {compl in
               guard case .finished = compl else {
                  XCTFail("Not finished as expected")
                  return
               }
               expectations[index].fulfill()
            }, receiveValue: {results in
               XCTAssertEqual(results.count, Book.numberOfChaptersInBookByNumber[book.number])
            })
            .store(in: &cancellables)
      }
      
      waitForExpectations(timeout: 20, handler: nil)
   }
}
