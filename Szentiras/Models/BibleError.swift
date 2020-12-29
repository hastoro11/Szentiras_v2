//
//  BibleError.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 26..
//

import Foundation

struct BibleError: Error {
   var description: String
   
   init(_ description: String) {
      self.description = description
   }
}
