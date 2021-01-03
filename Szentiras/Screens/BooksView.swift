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
         Header(showChapters: $showChapters, showTranslations: $showTranslations, showSettings: false)
         booksGrid
         Spacer()
      }
      .navigationBarTitleDisplayMode(.inline)
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
   // Functions
   //--------------------------------
   func selectBook(_ book: Book) {
      controller.activeBook = book      
      showChapters = true
   }
}

//--------------------------------
// Preview
//--------------------------------
struct BooksView_Previews: PreviewProvider {
   static var biblectrl = BibleController.preview(SavedDefault())
   static var previews: some View {
      BooksView()
         .environmentObject(biblectrl)
   }
}
