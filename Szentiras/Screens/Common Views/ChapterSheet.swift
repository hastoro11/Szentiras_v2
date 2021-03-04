//
//  ChapterSheet.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 30..
//

import SwiftUI

struct ChapterSheet: View {
   @EnvironmentObject var controller: BibleController
   @Binding var showChapters: Bool
   @Binding var selectedChapter: Int
   var body: some View {
      let columns = [GridItem(.adaptive(minimum: 44, maximum: 44))]
      let book = controller.activeBook
      var backgroundColor: Color {
         return controller.activeBook.id < 200 ? Color.Theme.green : Color.Theme.blue
      }
      return ScrollView {
         Text(book.name)
            .font(.medium(16))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
         LazyVGrid(columns: columns) {
            ForEach(1...book.numberOfChapters, id: \.self) { chapter in
               // Chapter selection
               CircleButton(
                  text: "\(chapter)",
                  backgroundColor: backgroundColor,
                  textColor: Color.white,
                  action: {
                  selectedChapter = chapter
                  controller.selectedTab = 1
                  showChapters = false
               })
            }
         }
      }
   }
}

struct ChapterSheet_Previews: PreviewProvider {
   static var controller = BibleController.preview(SavedDefault())
    static var previews: some View {
      ChapterSheet(showChapters: .constant(false), selectedChapter: .constant(1))         
         .environmentObject(controller)
    }
}
