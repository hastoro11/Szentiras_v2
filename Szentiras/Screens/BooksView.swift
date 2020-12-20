//
//  BooksView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 19..
//

import SwiftUI

// MARK: - BooksView
struct BooksView: View {
   @EnvironmentObject var bibleController: BibleController
   @State var showTranslations: Bool = false
   //--------------------------------
   // Body
   //--------------------------------
   var body: some View {
      VStack {
         booksGrid
      }
      .toolbar(content: {
         bookToolbar
         titleToolbar
         translationToolbar
      })
      .actionSheet(isPresented: $showTranslations, content: {
         ActionSheet(title: Text("Válassz egy fordítást"), buttons: bibleController.translationButtons)
      })
   }
   
   //--------------------------------
   // ToolbarItems
   //--------------------------------
   var bookToolbar: some ToolbarContent {
      ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
         Text("Móz")
            .font(.headline)
      }
   }
   
   var titleToolbar: some ToolbarContent {
      ToolbarItem(placement: ToolbarItemPlacement.principal) {
         Text(bibleController.translation.short)
            .bold()
      }
   }
   
   var translationToolbar: some ToolbarContent {
      ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
         Label(
            title: { Text("Ford") },
            icon: { Image(systemName: "bubble.left.and.bubble.right.fill") }
         )
         .foregroundColor(.green)
         .onTapGesture {
            showTranslations.toggle()
         }
      }
   }
   
   //--------------------------------
   // BooksGrid
   //--------------------------------
   @ViewBuilder var booksGrid: some View {
      Text("Hello, world! \(bibleController.translation.name)")
      Text("First book: \(bibleController.books[0].abbrev)")
      Text("No of books: \(bibleController.books.count)")
   }
}

// MARK: - Preview
struct BooksView_Previews: PreviewProvider {
   static var biblectrl = BibleController.preview(Translation())
   static var previews: some View {
      NavigationView {
         BooksView()
            .environmentObject(biblectrl)
      }
   }
}
