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
   var body: some View {
      let columns = [GridItem(.adaptive(minimum: 44, maximum: 44))]
      let book = controller.activeBook
      return ScrollView {
         Text(book.name)
         LazyVGrid(columns: columns) {
            ForEach(1...book.numberOfChapters, id: \.self) { chapter in
               // Chapter selection
               CircleButton(text: "\(chapter)", color: Color.green, action: {
                  controller.activeChapter = chapter
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
      ChapterSheet(showChapters: .constant(false))
         .environmentObject(controller)
    }
}
