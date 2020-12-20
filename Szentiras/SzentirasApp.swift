//
//  SzentirasApp.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import SwiftUI

@main
struct SzentirasApp: App {
   @StateObject var bibleController: BibleController
   init() {
      let trans = UserDefaults.getTranslation()
      let biblectrl = BibleController(translation: trans)
      _bibleController = StateObject(wrappedValue: biblectrl)
   }
    var body: some Scene {
        WindowGroup {
         ContentView()
            .environmentObject(bibleController)
        }
    }
}
