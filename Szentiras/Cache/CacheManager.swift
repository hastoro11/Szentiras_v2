//
//  CacheManager.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 02. 24..
//

import Foundation

class CacheManager {
    static var instance: CacheManager = CacheManager()
    private init() {}
    
    private(set) var results: [String: [[Vers]]] = [:]
    
    func addBook(key: String, verses: [[Vers]]) {
        results[key] = verses
    }
    
    func isBookSaved(key: String) -> Bool {
        results.keys.contains(key)
    }
    
    func getVerses(key: String) -> [[Vers]] {
        results[key] ?? [[]]
    }    
}
