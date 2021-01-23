//
//  ChapterTextView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 31..
//

import SwiftUI

struct ChapterTextView: View {
   @EnvironmentObject var model: ReadingTabsViewModel
   @EnvironmentObject var bookmarkController: BookmarkController
   @Binding var verses: [Vers]
   @State var hideNavigationBar: Bool = false
   var book: Book
   var chapter: Int
   @Binding var showBookmarkingView: Bool
   //--------------------------------
   // Body
   //--------------------------------
   var body: some View {
      ScrollView(.vertical, showsIndicators: false) {
         bookHeader         
         if model.isTextContinous {
            continuousView
         } else {
            versesView
         }
      }
      .padding(.horizontal)
      .navigationBarHidden(hideNavigationBar)      
   }
   
   //--------------------------------
   // Book header
   //--------------------------------
   @ViewBuilder
   var bookHeader: some View {
      VStack {
         Text(book.name)
            .layoutPriority(1)
            .lineLimit(3)
            .font(.bold(model.fontSize+6))
            .multilineTextAlignment(.center)
            
         Text("\(chapter). fejezet")
            .font(.medium(model.fontSize+4))
            .bold()
      }
      .padding(.vertical)
   }
   
   //--------------------------------
   // Verses view
   //--------------------------------
   var versesView: some View {
      return LazyVStack(alignment: .leading, spacing: 6) {
         ForEach(verses) { vers in
            HStack {
               if model.showIndex {
                  Group {
                     Text(vers.index).font(.medium(model.fontSize)) +
                        Text(" " + vers.szoveg.strippedHTMLElements)
                        .font(.light(model.fontSize))
                        
                  }
                  .lineSpacing(6)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(bookmarkController.getBookmarkColor(gepi: String(vers.hely.gepi)).opacity(0.4))
               } else {
                  Text(vers.szoveg.strippedHTMLElements)
                     .font(.light(model.fontSize))
                     .lineSpacing(6)
                     .padding(.bottom, 1)
               }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
               showBookmarkingView.toggle()
               bookmarkController.selectedVers = vers
            }
         }
      }
      .padding(.bottom, 40)
   }
   
   //--------------------------------
   // Continuous view
   //--------------------------------
   var continuousView: some View {
      let continuousVerses = verses.reduce("", {result, vers -> String in
         return result + " " + vers.szoveg.strippedHTMLElements
      })
      var indexedVerses = Text("")
      for vers in verses {
         // swiftlint:disable shorthand_operator
         indexedVerses = indexedVerses + Text("\(vers.index) ").font(.medium(model.fontSize))
         indexedVerses = indexedVerses + Text("\(vers.szoveg.strippedHTMLElements) ").font(.light(model.fontSize))
      }
      return LazyVStack {
         if model.showIndex {
            indexedVerses
               .font(.light(model.fontSize))
               .lineSpacing(6)
         } else {
            Text(continuousVerses)
               .font(.light(model.fontSize))
               .lineSpacing(6)
         }
      }
      .padding(.bottom, 40)
   }
}

//--------------------------------
// Preview
//--------------------------------
struct ChapterTextView_Previews: PreviewProvider {
   static var previews: some View {
      ChapterTextView(
         verses: .constant(Vers.mockData),
         book: Book.defaultBook(for: Translation.init()),
         chapter: 1,
         showBookmarkingView: .constant(false))
         .environmentObject(ReadingTabsViewModel())
   }
}
