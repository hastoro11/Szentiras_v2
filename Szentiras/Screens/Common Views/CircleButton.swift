//
//  CircleButton.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 01. 03..
//

import SwiftUI

struct CircleButton: View {
   var size: CGFloat = 44
   var image: String?
   var text: String?
   var backgroundColor: Color
   var textColor: Color
   var action: () -> Void
   //--------------------------------
   // Body
   //--------------------------------
   var body: some View {
      Button(action: action, label: {
         Circle()
            .foregroundColor(backgroundColor)
            .frame(width: size, height: size)
            .overlay(
               Group {
                  if text != nil {
                     Text(text!)
                  } else {
                     Image(systemName: image!)
                  }
               }
               .font(.medium(14))
               .foregroundColor(textColor)
            )
      })
   }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
      CircleButton(text: "1Móz", backgroundColor: Color.Theme.red, textColor: Color.white, action: {})
         .previewLayout(.sizeThatFits)
         .padding()
    }
}
