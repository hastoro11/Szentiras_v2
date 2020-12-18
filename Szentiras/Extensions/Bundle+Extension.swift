//
//  Bundle+Extension.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import Foundation

extension Bundle {
   func decode<T: Decodable>(file: String) -> [T] {
      guard let url = self.url(forResource: file, withExtension: nil) else {
         fatalError("Error loading file: \(file) from bundle")
      }
      guard let data = try? Data(contentsOf: url) else {
         fatalError("Error transferring file \(file) from bundle")
      }
      
      do {
         return try JSONDecoder().decode([T].self, from: data)
      } catch DecodingError.dataCorrupted(let context) {
         fatalError("Corrupted data error in bundle - \(context.debugDescription)")
      } catch DecodingError.keyNotFound(let key, let context) {
         fatalError("Key \(key) not found error in bundle - \(context.debugDescription)")
      } catch DecodingError.valueNotFound(let value, let context) {
         fatalError("Value \(value) not found error in bundle - \(context.debugDescription)")
      } catch DecodingError.typeMismatch(let type, let context) {
         fatalError("Type \(type) mismatch error in bundle - \(context.debugDescription)")
      } catch {
         fatalError("Decoding error in bundle - \(error.localizedDescription)")
      }
      
      return []
   }
   
}
