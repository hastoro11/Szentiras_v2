//
//  Toolbars.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 30..
//

import SwiftUI

struct Toolbars: ToolbarContent {
   @Binding var selectedTab: Int
   @Binding var book: Book
   @Binding var chapter: Int
   @Binding var translation: String
   @Binding var showChapters: Bool
   @Binding var showTranslations: Bool
   var paging: (BibleController.PagingDirection) -> Void
   
   var body: some ToolbarContent {
      bookToolbar
      titleToolbar
      translationToolbar
   }
   
   var bookToolbar: some ToolbarContent {
      ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
         HStack {
            CircleButton(
               size: 34,
               text: book.abbrev,
               backgroundColor: Color.Theme.dark,
               textColor: .white,
               action: {
                  selectedTab = 0
               })
            CircleButton(
               size: 34,
               text: "\(chapter)",
               backgroundColor: Color.Theme.yellow,
               textColor: Color.Theme.dark,
               action: {
                  showChapters.toggle()
               })            
         }
      }
   }
   
   var titleToolbar: some ToolbarContent {
      Group {
         ToolbarItem(placement: ToolbarItemPlacement.principal) {
            HStack {
               Button(action: {
                  paging(BibleController.PagingDirection.previous)
               }, label: {
                  Image(systemName: "chevron.left")
                     .font(.medium(22))
               })
               .disabled(chapter == 1)
               .accentColor(chapter == 1 ? .gray : Color.Theme.dark)
               
               Spacer()
               Button(action: {
                  showTranslations.toggle()
               }, label: {
                  Text(translation)
                     .font(.medium(16))
               })
               Spacer()
               Button(action: {
                  paging(BibleController.PagingDirection.next)
               }, label: {
                  Image(systemName: "chevron.right")
                     .font(.medium(22))
               })
               .disabled(chapter == book.numberOfChapters)
               .accentColor(chapter == book.numberOfChapters ? .gray : Color.Theme.dark)
            }
            .accentColor(Color.Theme.dark)
         }
      }
   }
   
   var translationToolbar: some ToolbarContent {
      ToolbarItem(placement: ToolbarItemPlacement.automatic) {
         HStack {
            CircleButton(
               size: 34,
               image: "textformat",
               backgroundColor: Color.Theme.green,
               textColor: .white,
               action: {
                  
               })
            CircleButton(
               size: 34,
               image: "bubble.left.and.bubble.right.fill",
               backgroundColor: Color.Theme.red,
               textColor: .white,
               action: {
                  showTranslations.toggle()
               })
            
         }
      }
   }
   
}

//struct Toolbars_Previews: PreviewProvider {
//   static var previews: some View {
//      Toolbars()
//   }
//}
