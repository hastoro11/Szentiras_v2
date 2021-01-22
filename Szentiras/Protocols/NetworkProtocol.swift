//
//  NetworkProtocol.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 01. 20..
//

import Foundation
import Combine

protocol NetworkProtocol {
   func fetchChapter(translation: Translation, book: Book, chapter: Int) -> AnyPublisher<SearchResult, BibleError>
   func fetchBook(translation: Translation, book: Book) -> AnyPublisher<[SearchResult], BibleError>
}
