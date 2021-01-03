//
//  ReadingTabsViewModel.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 01. 03..
//

import SwiftUI

class ReadingTabsViewModel: ObservableObject {
   @Published var fontSize: CGFloat = 16
   @Published var showIndex: Bool = true
   @Published var isTextContinous: Bool = false
   
}
