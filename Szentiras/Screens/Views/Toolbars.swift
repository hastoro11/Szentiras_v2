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
            Button(action: {
               selectedTab = 0
            }, label: {
               Text(book.abbrev)
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
   
   var titleToolbar: some ToolbarContent {
      Group {
         ToolbarItem(placement: ToolbarItemPlacement.principal) {
            HStack {
               Button(action: {
                  paging(BibleController.PagingDirection.previous)
               }, label: {
                  Image(systemName: "chevron.left")
               })
               .disabled(chapter == 1)
               Button(action: {
                  showTranslations.toggle()
               }, label: {
                  Text(translation)
                     .bold()
               })
               
               Button(action: {
                  paging(BibleController.PagingDirection.next)
               }, label: {
                  Image(systemName: "chevron.right")
               })
               .disabled(chapter == book.numberOfChapters)
            }
         }
      }
   }
   
   var translationToolbar: some ToolbarContent {
      ToolbarItem(placement: ToolbarItemPlacement.automatic) {
         HStack {
            Button(action: {
               showTranslations.toggle()
            }, label: {
               Image(systemName: "bubble.left.and.bubble.right.fill")
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
