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
    @EnvironmentObject var controller: BookmarkController
    
    var bookmarks: FetchRequest<Bookmark>
    
    init() {
        bookmarks = FetchRequest(
            entity: Bookmark.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Bookmark.order_, ascending: true)])
    }
    
    var sortedBookmarks: [String: [Bookmark]] {
        print(controller.sortedBookmarks)
        return controller.sortedBookmarks
    }
    
    var body: some View {
        VStack {
            Text("Könyvjelzők")
                .font(.medium(16))
                .fixedSize()
                .frame(height: 44)
            
            List {
                ForEach(Array(sortedBookmarks.keys.sorted()), id: \.self) { color in
                    if !sortedBookmarks[color]!.isEmpty {
                        Section(header: header(color)) {
                            ForEach(sortedBookmarks[color]!.sorted()) { bookmark in
                                row(bookmark)
                            }
                            .onDelete(perform: { indexSet in
                                print("on delete")
                            })
                        }
                    }
                    
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    func header(_ color: String) -> some View {
        Rectangle()
            .fill(Color(color))
//            .frame(height: 10)
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
