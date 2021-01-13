//
//  String+Extension.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 24..
//

import Foundation

extension String {
    var strippedHTMLElements: String {
        var str = self
        if str.range(of: #"<.*?>"#, options: .regularExpression) != nil {
         str = str.replacingOccurrences(of: #"<.*?>"#, with: "", options: .regularExpression)
        }
        return str
    }
}
