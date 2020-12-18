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
      let tr = UserDefaults.getTranslation()
      let bc = BibleController(translation: tr)
      _bibleController = StateObject(wrappedValue: bc)
   }
    var body: some Scene {
        WindowGroup {
         ContentView()
            .environmentObject(bibleController)
        }
    }
}
