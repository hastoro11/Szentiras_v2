//
//  ContentView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import SwiftUI
import CoreData

struct ContentView: View {
   @EnvironmentObject var bibleController: BibleController
   
   var body: some View {
      TabView(selection: $bibleController.selectedTab) {
         BooksView()
            .tag(0)
            .tabItem {
               Image(systemName: "books.vertical")
               Text("Könyvek")
            }
         ReadingTabsView()
            .tag(1)
            .tabItem {
               Image(systemName: "book")
               Text("Olvasás")
            }
         BookmarksView()
            .tag(2)
            .tabItem {
               Image(systemName: "bookmark")
               Text("Könyvjelzők")
            }
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var biblectrl = BibleController.preview(SavedDefault())
   static var previews: some View {
         ContentView()
            .environmentObject(biblectrl)
   }
}
