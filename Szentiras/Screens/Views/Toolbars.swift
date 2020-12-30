//
//  Toolbars.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 30..
//

import SwiftUI

struct Toolbars: ToolbarContent {
   var controller: BibleController
   @Binding var showTranslations: Bool
    var body: some ToolbarContent {
         bookToolbar
         titleToolbar
         translationToolbar      
    }
   
   var bookToolbar: some ToolbarContent {
      ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
         HStack {
            Text(controller.activeBook.abbrev.prefix(4))
               .font(.headline)
            Text("\(controller.activeChapter)")
               .font(.headline)

         }
      }
   }
   
   var titleToolbar: some ToolbarContent {
      ToolbarItem(placement: ToolbarItemPlacement.principal) {
         Text(controller.translation.short)
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
}
