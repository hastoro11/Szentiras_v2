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
//    @Binding var editMode: EditMode
    var bookmarks: FetchRequest<Bookmark>
    
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
                    editButton
                }
                .padding(.horizontal)
            }
            
            List {
                ForEach(Array(controller.sortedBookmarks.keys.sorted()), id: \.self) { color in
                    if !controller.sortedBookmarks[color]!.isEmpty {
                        Section(header: header(color)) {
                            ForEach(controller.sortedBookmarks[color]!.sorted()) { bookmark in
                                row(bookmark)
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
    
    var editButton: some View {
        Button(action: {
            withAnimation {
                editMode?.wrappedValue = editMode?.wrappedValue == .active ? .inactive : .active
            }
        }, label: {
            Image(
                systemName: editMode?.wrappedValue == .inactive ? "arrow.up.arrow.down.circle.fill" : "checkmark.circle.fill")
                .font(.system(size: 34, weight: .light, design: .default))
                .foregroundColor(editMode?.wrappedValue == .active ? Color.Theme.red : Color.Theme.blue)
            
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
            Text(bookmark.szoveg)
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
        }
        
    }
}
