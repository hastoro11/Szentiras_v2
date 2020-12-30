//
//  ReadingView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 12. 29..
//

import SwiftUI

struct ReadingView: View {
   @EnvironmentObject var controller: BibleController
   @State var showTranslations: Bool = false
   var body: some View {
      VStack {
         ScrollView {
            Text(controller.activeBook.name)
               .font(.title)
               .bold()
               .multilineTextAlignment(.center)
            Text("\(controller.activeChapter). fejezet")
               .font(.title3)
               .bold()
            ForEach(controller.verses) { vers in
               HStack {
                  Text(vers.index).bold() +
                     Text(" " + vers.szoveg)
               }
               .frame(maxWidth: .infinity, alignment: .leading)
            }
         }
      }
      .toolbar(content: {
         Toolbars(controller: controller, showTranslations: $showTranslations)
      })
      .actionSheet(isPresented: $showTranslations, content: {
         ActionSheet(title: Text("Válassz egy fordítást"), buttons: controller.translationButtons)
      })
      .navigationBarTitleDisplayMode(.inline)
   }
}

struct ReadingView_Previews: PreviewProvider {
   static var biblectrl = BibleController.preview(SavedDefault())
   static var previews: some View {
      NavigationView {
         ReadingView()
            .environmentObject(biblectrl)
      }
   }
}
