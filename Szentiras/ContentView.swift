//
//  ContentView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 18..
//

import SwiftUI

struct ContentView: View {
   @EnvironmentObject var bibleController: BibleController
   @State var showTranslations: Bool = false
   var translations: [ActionSheet.Button] {
      var trs = Translation.all().map({ tr -> ActionSheet.Button in
         ActionSheet.Button.default(Text(tr.name), action: {
            bibleController.translation = tr
            UserDefaults.setTranslation(abbrev: tr.abbrev)
         })
      })
      trs.append(ActionSheet.Button.cancel(Text("Mégsem")))
      return trs
   }
   var body: some View {
      NavigationView {
         VStack {
            Text("Hello, world! \(bibleController.translation.name)")
            Text("First book: \(bibleController.books[0].abbrev)")
            Text("No of books: \(bibleController.books.count)")
         }
          
            .toolbar(content: {
               Button(action: {showTranslations.toggle()}, label: {
                  Image(systemName: "bubble.left.and.bubble.right")
               })
            })
            .actionSheet(isPresented: $showTranslations, content: {
               ActionSheet(title: Text("Válassz egy fordítást"), buttons: translations)
         })
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var bc = BibleController.preview(Translation())
   static var previews: some View {
      NavigationView {
         ContentView()
            .environmentObject(bc)
      }
   }
}
