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
    
    var results: [String: [[Vers]]] = [:]
}
