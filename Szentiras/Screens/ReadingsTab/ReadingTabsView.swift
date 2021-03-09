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
    @State var showBookmarkingView: Bool = false
    @State var hidenavigationBar: Bool = false
    
    @StateObject var model: ReadingTabsViewModel = ReadingTabsViewModel()
    @EnvironmentObject var bookmarkController: BookmarkController
    //--------------------------------
    // Body
    //--------------------------------
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if !hidenavigationBar {
                    Header(
                        showChapters: $showChapters,
                        showTranslations: $showTranslations,
                        showSettingsView: $showSettingsView)
                        .animation(.easeInOut)
                        .transition(AnyTransition.offset(x: 0, y: -70))
                }
                
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
                        } else {
                            ErrorMessageView(action: controller.fetchBook)
                        }
                    }
                }
                .animation(.easeInOut)
            }
            
            if showSettingsView {
                Color.primary
                    .edgesIgnoringSafeArea(.top)
                    .opacity(0.15)
                    .onTapGesture {
                        showSettingsView.toggle()
                    }
                    .animation(.easeInOut)
                    .zIndex(5)
                TextSettingsView(model: model)
                    .animation(.spring())
                    .transition(.move(edge: .bottom))
                    .zIndex(10)
            }
            
            if showBookmarkingView {
                Color.primary
                    .edgesIgnoringSafeArea(.top)
                    .opacity(0.15)
                    .onTapGesture {
                        showBookmarkingView.toggle()
                    }
                    .animation(.easeInOut)
                    .zIndex(5)
                BookmarkingView(showBookmarkingView: $showBookmarkingView)
                    .animation(.spring())
                    .transition(.move(edge: .bottom))
                    .zIndex(10)
            }
        }
        .sheet(isPresented: $showChapters, onDismiss: {
            controller.chapterViewOnDismiss(selectedChapter: selectedChapter)
        }) {
            ChapterSheet(showChapters: $showChapters, selectedChapter: $selectedChapter)
                .environmentObject(controller)
        }        
    }
    
    //--------------------------------
    // Tabview
    //--------------------------------
    var tabview: some View {
        TabView(selection: $controller.activeChapter) {
            ForEach(1...controller.versesInBook.count, id: \.self) { index in
                ChapterTextView(
                    verses: $controller.versesInBook[index-1],
                    hideNavigationBar: $hidenavigationBar,
                    book: controller.activeBook,
                    chapter: controller.activeChapter,
                    showBookmarkingView: $showBookmarkingView
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
            .environmentObject(ctrl)
    }
}
