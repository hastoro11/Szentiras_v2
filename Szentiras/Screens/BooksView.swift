//
//  BooksView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 19..
//

import SwiftUI

// MARK: - BooksView
struct BooksView: View {   
   @EnvironmentObject var controller: BibleController
   @State var showTranslations: Bool = false
   @State var showChapters: Bool = false
   @State var selectedChapter: Int = 0
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
         toolbars
      })
      .actionSheet(isPresented: $showTranslations, content: {
         ActionSheet(title: Text("Válassz egy fordítást"), buttons: controller.translationButtons)
      })
      .sheet(isPresented: $showChapters, onDismiss: {
         controller.chapterViewOnDismiss(selectedChapter: selectedChapter)
      }) {
         ChapterSheet(showChapters: $showChapters, selectedChapter: $selectedChapter)
            .environmentObject(controller)
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
            ForEach(controller.books.filter({$0.number < 200})) { book in
               CircleButton(text: String(book.abbrev.prefix(4)), color: Color.green, action: {
                  selectBook(book)
               })
            }
         }
         Text("Újszövetség")
         LazyVGrid(columns: columns) {
            ForEach(controller.books.filter({$0.number >= 200})) { book in
               CircleButton(text: String(book.abbrev.prefix(4)), color: Color.blue, action: {
                  selectBook(book)
               })
            }
         }
      }
   }
   
   //--------------------------------
   // Toolbars
   //--------------------------------
   var toolbars: some ToolbarContent {
      Toolbars(selectedTab: $controller.selectedTab,
               book: $controller.activeBook,
               chapter: $controller.activeChapter,
               translation: $controller.translation.short,
               showChapters: $showChapters,
               showTranslations: $showTranslations,
               paging: controller.paging)
   }
   
   //--------------------------------
   // Functions
   //--------------------------------
   func selectBook(_ book: Book) {
      controller.activeBook = book      
      showChapters = true
   }
}

struct BookToolbar: ToolbarContent {
   @Binding var book: Book
   @Binding var chapter: Int
   @Binding var selectedTab: Int
   @Binding var showChapters: Bool
   var body: some ToolbarContent {
      ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
         HStack {
            Button(action: {
               selectedTab = 0
            }, label: {
               Text(book.abbrev.prefix(4))
                  .font(.headline)
            })
            Button(action: {
               showChapters.toggle()
            }, label: {
               Text("\(chapter)")
                  .font(.headline)
            })
            
         }
      }
   }
}

//--------------------------------
// CircleButton
//--------------------------------
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

//--------------------------------
// Preview
//--------------------------------
struct BooksView_Previews: PreviewProvider {
   static var biblectrl = BibleController.preview(SavedDefault())
   static var previews: some View {
      NavigationView {
         BooksView()
            .environmentObject(biblectrl)
      }
   }
}
