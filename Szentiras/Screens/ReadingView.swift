//
//  ReadingView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 29..
//

import SwiftUI

struct ReadingView: View {
   @EnvironmentObject var controller: BibleController
   @State var showTranslations: Bool = false
   @State var showChapters: Bool = false
   @State var selectedChapter: Int = 0
      
   //--------------------------------
   // Body
   //--------------------------------
   var body: some View {
      Group {
         if controller.isLoading {
            ProgressView("Keresés...")
         } else {
            ScrollView {
               bookHeader
               versesView
            }
         }
      }
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
      .navigationBarTitleDisplayMode(.inline)
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
   // Chapter text
   //--------------------------------
   var versesView: some View {
      ForEach(controller.verses) { vers in
         HStack {
            Text(vers.index).bold() +
               Text(" " + vers.szoveg)
         }
         .frame(maxWidth: .infinity, alignment: .leading)
      }
   }
   
   //--------------------------------
   // Book header
   //--------------------------------
   @ViewBuilder
   var bookHeader: some View {
      Text(controller.activeBook.name)
         .font(.title)
         .bold()
         .multilineTextAlignment(.center)
      Text("\(controller.activeChapter). fejezet")
         .font(.title3)
         .bold()
   }
   
}

//--------------------------------
// Preview
//--------------------------------
struct ReadingView_Previews: PreviewProvider {
   static var biblectrl = BibleController.preview(SavedDefault())
   static var previews: some View {
      NavigationView {
         ReadingView()
            .environmentObject(biblectrl)
      }
   }
}
