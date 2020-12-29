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
   @State var showChapters: Bool = false
   
   //--------------------------------
   // Body
   //--------------------------------
   var body: some View {
      VStack {
         booksGrid
         Spacer()
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar(content: {
         bookToolbar
         titleToolbar
         translationToolbar
      })
      .actionSheet(isPresented: $showTranslations, content: {
         ActionSheet(title: Text("Válassz egy fordítást"), buttons: bibleController.translationButtons)
      })
      .sheet(isPresented: $showChapters, onDismiss: bibleController.chapterViewOnDismiss) {
         chapterSheet
      }
   }
   
   //--------------------------------
   // ToolbarItems
   //--------------------------------
   var bookToolbar: some ToolbarContent {
      ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
         HStack {
            Text(bibleController.activeBook.abbrev.prefix(4))
               .font(.headline)
            Text("\(bibleController.activeChapter)")
               .font(.headline)

         }
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
   var booksGrid: some View {
      let columns = [GridItem(.adaptive(minimum: 44, maximum: 44))]
      return ScrollView {
         Text("Ószövetség")
         LazyVGrid(columns: columns) {
            ForEach(bibleController.books.filter({$0.number < 200})) { book in
               CircleButton(text: String(book.abbrev.prefix(4)), color: Color.green, action: {
                  selectBook(book)
               })
            }
         }
         Text("Újszövetség")
         LazyVGrid(columns: columns) {
            ForEach(bibleController.books.filter({$0.number >= 200})) { book in
               CircleButton(text: String(book.abbrev.prefix(4)), color: Color.blue, action: {
                  selectBook(book)
               })
            }
         }
      }
   }
   
   //--------------------------------
   // ChapterSheet
   //--------------------------------
   var chapterSheet: some View {
      let columns = [GridItem(.adaptive(minimum: 44, maximum: 44))]
      let book = bibleController.activeBook
      return ScrollView {
         Text(book.name)
         LazyVGrid(columns: columns) {
            ForEach(1...book.numberOfChapters, id: \.self) { chapter in
               // Chapter selection
               CircleButton(text: "\(chapter)", color: Color.green, action: {
                  bibleController.activeChapter = chapter
                  bibleController.selectedTab = 1
                  showChapters = false                  
               })
            }
         }
      }
   }
   //--------------------------------
   // Functions
   //--------------------------------
   func selectBook(_ book: Book) {
      bibleController.activeBook = book
      showChapters = true
   }
}

struct CircleButton: View {
   var text: String
   var color: Color
   var action: () -> Void
   var body: some View {
      Button(action: action, label: {
         Circle()
            .foregroundColor(color)
            .frame(width: 44, height: 44)
            .overlay(Text(text).font(.subheadline).accentColor(.primary))
      })
   }
}

// MARK: - Preview
struct BooksView_Previews: PreviewProvider {
   static var biblectrl = BibleController.preview(SavedDefault())
   static var previews: some View {
      NavigationView {
         BooksView()
            .environmentObject(biblectrl)
      }
   }
}
