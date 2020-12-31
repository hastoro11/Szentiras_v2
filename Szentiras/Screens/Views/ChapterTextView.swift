//
//  ChapterTextView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 31..
//

import SwiftUI

struct ChapterTextView: View {
   @Binding var verses: [Vers]
   var book: Book
   var chapter: Int
   //--------------------------------
   // Body
   //--------------------------------
   var body: some View {
      ScrollView {
         bookHeader
         versesView
      }
   }
   
   //--------------------------------
   // Book header
   //--------------------------------
   @ViewBuilder
   var bookHeader: some View {
      Text(book.name)
         .font(.title)
         .bold()
         .multilineTextAlignment(.center)
      Text("\(chapter). fejezet")
         .font(.title3)
         .bold()
   }
   
   //--------------------------------
   // Verses view
   //--------------------------------
   var versesView: some View {
      ForEach(verses) { vers in
         HStack {
            Text(vers.index).bold() +
               Text(" " + vers.szoveg)
         }
         .frame(maxWidth: .infinity, alignment: .leading)
      }
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
