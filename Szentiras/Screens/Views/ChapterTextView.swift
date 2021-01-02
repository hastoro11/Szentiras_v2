//
//  ChapterTextView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 31..
//

import SwiftUI

struct ChapterTextView: View {
   @Binding var verses: [Vers]
   @State var hideNavigationBar: Bool = false
   var book: Book
   var chapter: Int
   //--------------------------------
   // Body
   //--------------------------------
   var body: some View {
      ScrollView(.vertical, showsIndicators: false) {
         bookHeader
         versesView
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
            .font(.bold(26))
            .multilineTextAlignment(.center)
            
         Text("\(chapter). fejezet")
            .font(.medium(22))
            .bold()
      }
      .padding(.vertical)
   }
   
   //--------------------------------
   // Verses view
   //--------------------------------
   var versesView: some View {
      LazyVStack {
         ForEach(verses) { vers in
            HStack {
               Text(vers.index).font(.medium(18)) +
                  Text(" " + vers.szoveg)
                  .font(.light(18))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
               hideNavigationBar.toggle()
            }
            .onLongPressGesture {
               print("long")
            }
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
      ChapterTextView(verses: .constant(Vers.mockData), book: Book.defaultBook(for: Translation.init()), chapter: 1)
   }
}
