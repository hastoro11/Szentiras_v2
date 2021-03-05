//
//  SettingsView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 02. 24..
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Beállítások")
                .font(.medium(16))
                .fixedSize()
                .frame(height: 44)
            Spacer()
            
            // http://sornyei.hu/szentiras/
            Button(action: {
                if UIApplication.shared.canOpenURL(URL(string: "http://sornyei.hu/szentiras")!) {
                    UIApplication.shared.open(URL(
                                                string: "http://sornyei.hu/szentiras")!,
                                              options: [:], completionHandler: nil)
                }
            }, label: {
                Text("Adatvédelmi szabályzat")
                    .font(.regular(16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.Theme.red)
                    .cornerRadius(8)
                    .padding()
                
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
