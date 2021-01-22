//
//  MockNetworkController.swift
//  SzentirasTests
//
//  Created by Gabor Sornyei on 2021. 01. 20..
//

import Foundation
import Combine
@testable import Szentiras

class MockNetworkController: NetworkProtocol {
   func fetchChapter(
      translation: Translation,
      book: Book,
      chapter: Int) -> AnyPublisher<SearchResult, BibleError> {
      let result: [SearchResult] = Bundle.main.decode(file: "search_result_Tit\(chapter).json")
      return Just(result.first!).setFailureType(to: BibleError.self).eraseToAnyPublisher()
   }
   
   func fetchBook(translation: Translation, book: Book) -> AnyPublisher<[SearchResult], BibleError> {
      let chapterOne = fetchChapter(translation: translation, book: book, chapter: 1)
      let chapterTwo = fetchChapter(translation: translation, book: book, chapter: 2)
      let chapterThree = fetchChapter(translation: translation, book: book, chapter: 3)
      return Publishers.MergeMany([chapterOne, chapterTwo, chapterThree])
         .collect()
         .eraseToAnyPublisher()
   } 
}
