//
//  ReadingTabsView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 30..
//

import SwiftUI

struct ReadingTabsView: View {
   @EnvironmentObject var controller: BibleController
   @State var showTranslations: Bool = false
   @State var showChapters: Bool = false
   @State var selectedChapter: Int = 1
   
   //--------------------------------
   // Body
   //--------------------------------
   var body: some View {
      VStack {
         Header(showChapters: $showChapters, showTranslations: $showTranslations)
         Group {
            if controller.isLoading {
               Spacer()
               ProgressView("Keresés...")
               Spacer()
            }
            if !controller.isLoading {
               if controller.versesInBook.count != 0 {
                  tabview
                     .id(controller.versesInBook.count)
               }
            }
         }
      }
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
   // Tabview
   //--------------------------------
   var tabview: some View {
      TabView(selection: $controller.activeChapter) {
         ForEach(1...controller.versesInBook.count, id: \.self) { index in
            ChapterTextView(
               verses: $controller.versesInBook[index-1],
               book: controller.activeBook,
               chapter: controller.activeChapter
            )
            .tag(index)
         }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))      
   }
}

//--------------------------------
// Preview
//--------------------------------
struct ReadingTabsView_Previews: PreviewProvider {
   static var ctrl = BibleController(savedDefault: SavedDefault())
   static var previews: some View {
      ReadingTabsView()
         .environmentObject(ctrl)
   }
}
