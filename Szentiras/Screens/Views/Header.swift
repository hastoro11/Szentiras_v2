//
//  Header.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 01. 03..
//

import SwiftUI

struct Header: View {
   @EnvironmentObject var controller: BibleController
   
   @Binding var showChapters: Bool
   @Binding var showTranslations: Bool
   @Binding var showSettingsView: Bool
   var isSettingsAvailable: Bool = true
   //--------------------------------
   // Body
   //--------------------------------
   var body: some View {
      HStack {
         Group {
            CircleButton(
               text: controller.activeBook.abbrev,
               backgroundColor: Color.Theme.dark,
               textColor: .white,
               action: {
                  controller.selectedTab = 0
               })
            
            CircleButton(
               text: "\(controller.activeChapter)",
               backgroundColor: Color.Theme.yellow,
               textColor: Color.Theme.dark,
               action: {
                  showChapters.toggle()
            })
         }
         Spacer()
         Spacer()
         Group {
            Button(action: {
               controller.paging(.previous)
            }, label: {
               Image(systemName: "chevron.left")
                  .font(.medium(22))
            })
            .accentColor(Color.Theme.dark)
            Spacer()
            Text(controller.translation.short)
               .font(.medium(16))
               .onTapGesture {
                  showTranslations.toggle()
               }
            Spacer()
            Button(action: {
               controller.paging(.next)
            }, label: {
               Image(systemName: "chevron.right")
                  .font(.medium(22))
            })
            .accentColor(Color.Theme.dark)
         }
         Spacer()
         Spacer()
         Group {
            CircleButton(
               image: "textformat",
               backgroundColor: Color.Theme.green,
               textColor: Color.white,
               action: {
                  showSettingsView.toggle()
               })
               .opacity(isSettingsAvailable ? 1.0 : 0.0)
            CircleButton(
               image: "bubble.left.and.bubble.right.fill",
               backgroundColor: Color.Theme.red,
               textColor: Color.white,
               action: {
                  showTranslations.toggle()
               })
         }
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal)
   }
}

//--------------------------------
// Preview
//--------------------------------
struct Header_Previews: PreviewProvider {
   static var controller = BibleController.preview(SavedDefault())
   static var previews: some View {
      Header(showChapters: .constant(false), showTranslations: .constant(false), showSettingsView: .constant(true))
         .environmentObject(controller)
         .previewLayout(.sizeThatFits)
   }
}
