//
//  Toolbars.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 30..
//

import SwiftUI

struct Toolbars: ToolbarContent {
   @Binding var selectedTab: Int
   @Binding var bookTitle: String
   @Binding var chapter: Int
   @Binding var translation: String
   @Binding var showChapters: Bool
   @Binding var showTranslations: Bool
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
               Text(bookTitle)
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
            Text(translation)
               .bold()
         }
      }
   }
   
   var translationToolbar: some ToolbarContent {
      Group {
         ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
            Label(
               title: { Text("Fordítás") },
               icon: { Image(systemName: "bubble.left.and.bubble.right.fill") }
            )
            .foregroundColor(.green)
            .onTapGesture {
               showTranslations.toggle()
            }
         }
      }
   }
}

//struct Toolbars_Previews: PreviewProvider {
//   static var previews: some View {
//      Toolbars()
//   }
//}
