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
   @State var showSettingsView: Bool = false
   
   @StateObject var model: ReadingTabsViewModel = ReadingTabsViewModel()
   //--------------------------------
   // Body
   //--------------------------------
   var body: some View {
      ZStack(alignment: .bottom) {
         VStack {
            Header(
               showChapters: $showChapters,
               showTranslations: $showTranslations,
               showSettingsView: $showSettingsView)
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
         if showSettingsView {
            Color.primary
               .edgesIgnoringSafeArea(.top)
               .opacity(0.15)
               .onTapGesture {
                  showSettingsView.toggle()
               }
            settingsView
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
   }
   
   //--------------------------------
   // SettingsView
   //--------------------------------
   var settingsView: some View {
      VStack {
         Rectangle()
            .frame(height: 0.5)
         VStack(spacing: 20) {
            HStack {
               Text("Betűméret")
                  .font(.medium(16))
               Slider(value: $model.fontSize, in: 14...22, step: 2)
            }
            HStack {
               Text("Versszámozás")
                  .font(.medium(16))
               Spacer()
               Toggle("", isOn: $model.showIndex)
            }
            HStack {
               Text("Folyamatos olvasás")
                  .font(.medium(16))
               Spacer()
               Toggle("", isOn: $model.isTextContinous)
            }
         }
         .padding(.horizontal)
         .padding(.top, 25)
      }
      .padding(.bottom, 25)
      .background(Color.Theme.light.shadow(radius: 12))
      
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
            .environmentObject(model)
         }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))      
   }
}

//--------------------------------
// Preview
//--------------------------------
struct ReadingTabsView_Previews: PreviewProvider {
   static var ctrl = BibleController(savedDefault: SavedDefault(), networkController: NetworkController.instance)
   static var previews: some View {
      ReadingTabsView()
         .preferredColorScheme(.dark)
         .environmentObject(ctrl)
   }
}
