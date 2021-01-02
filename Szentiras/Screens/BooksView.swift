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
   @State var selectedChapter: Int = 1
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
            .font(.medium(16))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
         LazyVGrid(columns: columns) {
            ForEach(controller.books.filter({$0.number < 200})) { book in
               CircleButton(
                  text: String(book.abbrev.prefix(4)),
                  backgroundColor: Color.Theme.green,
                  textColor: Color.white,
                  action: { selectBook(book) })
            }
         }
         Text("Újszövetség")
            .font(.medium(16))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
         LazyVGrid(columns: columns) {
            ForEach(controller.books.filter({$0.number >= 200})) { book in
               CircleButton(
                  text: String(book.abbrev.prefix(4)),
                  backgroundColor: Color.Theme.blue,
                  textColor: Color.white,
                  action: { selectBook(book) })
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
   var size: CGFloat = 44
   var image: String?
   var text: String?
   var backgroundColor: Color
   var textColor: Color
   var action: () -> Void
   var body: some View {
      Button(action: action, label: {
         Circle()
            .foregroundColor(backgroundColor)
            .frame(width: size, height: size)
            .overlay(
               Group {
                  if text != nil {
                     Text(text!)
                  } else {
                     Image(systemName: image!)                        
                  }
               }
               .font(.medium(14))
               .foregroundColor(textColor)
            )
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
      CircleButton(text: "Ruth", backgroundColor: .green, textColor: .black, action: {})
         .previewLayout(.sizeThatFits).padding()
   }
}
