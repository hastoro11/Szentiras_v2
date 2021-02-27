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
                            Spacer()
                            Text("A szervert nem lehet elérni, lehetséges, hogy nincs internetcsatlakozás?\nVálassz ki újból egy könyvet a frissítéshez.")
                                .multilineTextAlignment(.center)
                                .font(.light(18))
                                .padding()
                            Spacer()
                            Spacer()
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
                settingsView
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
                bookmarkingView
                    .animation(.spring())
                    .transition(.move(edge: .bottom))
                    .zIndex(10)
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
    // BookmarkingView
    //--------------------------------
    var bookmarkingView: some View {
        VStack {
            Rectangle()
                .frame(height: 0.5)
            VStack(spacing: 10) {
                Text("Igevers megjelölése")
                    .font(.medium(16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                HStack(spacing: 10) {
                    ForEach(["Blue", "Green", "Red", "Yellow"], id: \.self) { color in
                        Circle()
                            .fill(Color(color)).frame(width: 34, height: 34)
                            .onTapGesture {
                                bookmarkController.addBookmark(color: color, translation: controller.translation.abbrev)
                                showBookmarkingView.toggle()
                            }
                    }
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 34, weight: .thin))
                        .onTapGesture {
                            bookmarkController.deleteBookmark()
                            showBookmarkingView.toggle()
                        }
                    Spacer()
                }
                
            }
            .padding(.horizontal)
            .padding(.top, 10)
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

struct BookmarkingView: View {
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 0.5)
            VStack(spacing: 10) {
                Text("Igevers megjelölése")
                    .font(.medium(16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                HStack(spacing: 10) {
                    ForEach(["Blue", "Green", "Red", "Yellow"], id: \.self) { color in
                        Circle()
                            .fill(Color(color)).frame(width: 34, height: 34)
                    }
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 34, weight: .thin))
                    Spacer()
                }
                
            }
            .padding(.horizontal)
            .padding(.top, 25)
        }
        .padding(.bottom, 25)
        .background(Color.Theme.light.shadow(radius: 12))
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
        BookmarkingView()
            .previewLayout(.sizeThatFits)
    }
}
