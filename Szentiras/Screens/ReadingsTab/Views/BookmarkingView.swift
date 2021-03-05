//
//  BookmarkingView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 03. 02..
//

import SwiftUI

struct BookmarkingView: View {
    @EnvironmentObject var bibleController: BibleController
    @EnvironmentObject var bookmarkController: BookmarkController
    @Binding var showBookmarkingView: Bool
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 0.5)
            VStack(spacing: 10) {
                HStack {
                    Text("Igevers megjelölése")
                    Spacer()
                    Text(bookmarkController.selectedVers?.hely.szep ?? "")
                }
                .font(.medium(16))
                .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                HStack(spacing: 10) {
                    ForEach(["Blue", "Green", "Red", "Yellow"], id: \.self) { color in
                        Circle()
                            .fill(Color(color)).frame(width: 34, height: 34)
                            .onTapGesture {
                                bookmarkController.addBookmark(
                                    color: color,
                                    translation: bibleController.translation.abbrev)
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
}

struct BookmarkingView_Previews: PreviewProvider {
    static var ctrl = BibleController(savedDefault: SavedDefault(), networkController: NetworkController.instance)
    static var previews: some View {
        BookmarkingView(showBookmarkingView: .constant(true))
            .environmentObject(ctrl)
            .environmentObject(BookmarkController(inMemory: true))
            .previewLayout(.sizeThatFits)
    }
}
