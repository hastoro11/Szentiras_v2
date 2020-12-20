//
//  ContentView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import SwiftUI

struct ContentView: View {
   @EnvironmentObject var bibleController: BibleController   
   @State var selection: Int = 0
   
   var body: some View {
      TabView(selection: $selection) {
         NavigationView {
            BooksView()
         }
            .tag(0)
            .tabItem {
               Image(systemName: "books.vertical")
               Text("Könyvek")
            }
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var biblectrl = BibleController.preview(Translation())
   static var previews: some View {
         ContentView()
            .environmentObject(biblectrl)
   }
}
