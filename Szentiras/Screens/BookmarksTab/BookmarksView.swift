//
//  BookmarksView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 01. 22..
//

import SwiftUI
import CoreData

struct BookmarksView: View {
    @Environment(\EnvironmentValues.managedObjectContext) var context
    @Environment(\EnvironmentValues.editMode) var editMode
    @EnvironmentObject var controller: BookmarkController
    @EnvironmentObject var bibleController: BibleController

    var bookmarks: FetchRequest<Bookmark>
    var emptyDictonary: Bool {
        if let reds = controller.sortedBookmarks["Red"],
           let yellows = controller.sortedBookmarks["Yellow"],
           let blues = controller.sortedBookmarks["Blue"],
           let greens = controller.sortedBookmarks["Green"] {
            return reds.isEmpty &&
                yellows.isEmpty &&
                greens.isEmpty &&
                blues.isEmpty
        }
       return false
    }
    init() {
        bookmarks = FetchRequest(
            entity: Bookmark.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Bookmark.order_, ascending: true)])
    }
    
    var body: some View {
        VStack {
            ZStack {
                Text("Könyvjelzők")
                    .font(.medium(16))
                    .fixedSize()
                    .frame(height: 44)
                    
                HStack {
                    Spacer()
                    if !emptyDictonary {
                        editButton
                    }
                }
                .padding(.horizontal)
            }
            if emptyDictonary {
                Spacer()
                Text("Még nincsenek könyvjelzők")
                    .font(.light(18))
                Spacer()
                Spacer()
            } else {
                List {
                    ForEach(Array(controller.sortedBookmarks.keys.sorted()), id: \.self) { color in
                        if !controller.sortedBookmarks[color]!.isEmpty {
                            Section(header: header(color)) {
                                ForEach(controller.sortedBookmarks[color]!.sorted()) { bookmark in
                                    row(bookmark)
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button(action: {
                                                bibleController.jumpToVers(bookmark: bookmark)
                                            }, label: {
                                                Label(
                                                    title: { Text("Ugrás a fejezethez") },
                                                    icon: { Image(systemName: "arrow.uturn.forward") })
                                            })
                                        }))
                                }
                                .onDelete(perform: { indexSet in
                                    controller.deleteBookmark(color: color, indexSet: indexSet)
                                })
                                .onMove(perform: { indices, newOffset in
                                    controller.moveBookmark(color: color, from: indices, to: newOffset)
                                })
                                
                            }
                        }
                        
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    var editButton: some View {
        Button(action: {
            withAnimation {
                editMode?.wrappedValue = editMode?.wrappedValue == .active ? .inactive : .active
            }
        }, label: {
            Image(
                systemName: editMode?.wrappedValue == .inactive ? "arrow.up.arrow.down" : "checkmark")
                .font(.medium(18))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Circle().fill(editMode?.wrappedValue == .active ? Color.Theme.red : Color.Theme.blue))
        })
    }
    
    func header(_ color: String) -> some View {
        Rectangle()
            .fill(Color(color))
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    func row(_ bookmark: Bookmark) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(bookmark.szep)
                    .font(.medium(16))
                Spacer()
                Text(bookmark.translation)
                    .font(.regular(12))
            }
            Text(bookmark.szoveg.strippedHTMLElements)
                .font(.light(16))
                .padding(.bottom, 5)
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var bookmarkController = BookmarkController(inMemory: true)
    static var previews: some View {
        NavigationView {
            BookmarksView()
                .environmentObject(bookmarkController)
                .environment(\.managedObjectContext, bookmarkController.container.viewContext)
                .navigationBarHidden(true)
                .environmentObject(BibleController(savedDefault: SavedDefault(), networkController: NetworkController.instance))
        }
        
    }
}
