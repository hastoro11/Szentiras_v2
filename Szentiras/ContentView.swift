//
//  ContentView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import SwiftUI

struct ContentView: View {
   @EnvironmentObject var bibleController: BibleController
   
   var body: some View {
      TabView(selection: $bibleController.selectedTab) {
         NavigationView {
            BooksView()
         }
            .tag(0)
            .tabItem {
               Image(systemName: "books.vertical")
               Text("Könyvek")
            }
         NavigationView {
            ReadingTabsView()
         }
            .tag(1)
            .tabItem {
               Image(systemName: "book")
               Text("Olvasás")
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
