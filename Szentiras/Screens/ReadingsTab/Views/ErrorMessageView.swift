//
//  ErrorMessageView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 03. 02..
//

import SwiftUI

struct ErrorMessageView: View {
    var action: () -> Void
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.icloud.fill")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("A szervert nem lehet elérni, lehetséges, hogy nincs internetcsatlakozás?")
                .multilineTextAlignment(.center)
                .font(.light(18))
                .padding()
            Button(action: action, label: {
                Label(
                    title: { Text("Frissítés").font(.regular(18)) },
                    icon: { Image(systemName: "arrow.triangle.2.circlepath") })
                    .font(.regular(18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.Theme.blue)
                    .cornerRadius(8)
                    .padding()
            })
            Spacer()
            Spacer()
        }
    }
}

struct ErrorMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessageView(action: {})
    }
}
