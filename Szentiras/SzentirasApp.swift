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
   @StateObject var bookmarkController: BookmarkController
   
   init() {
      let savedDefault = UserDefaults.getSavedData()
      let biblectrl = BibleController(savedDefault: savedDefault, networkController: NetworkController.instance)
      _bibleController = StateObject(wrappedValue: biblectrl)
      _bookmarkController = StateObject(wrappedValue: BookmarkController(inMemory: true))
   }
   
   var body: some Scene {
      WindowGroup {
         ContentView()
            .environment(\.managedObjectContext, bookmarkController.container.viewContext)
            .environmentObject(bookmarkController)
            .environmentObject(bibleController)
      }
   }
}
