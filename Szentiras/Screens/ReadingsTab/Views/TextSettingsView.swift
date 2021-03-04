//
//  TextSettingsView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 03. 02..
//

import SwiftUI

struct TextSettingsView: View {
    @ObservedObject var model: ReadingTabsViewModel
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 0.5)
            VStack(spacing: 20) {
                HStack {
                    Text("Betűméret")
                        .font(.medium(16))
                    Slider(value: $model.fontSize, in: 14...22, step: 2)
                }
                HStack {
                    Text("Versszámozás")
                        .font(.medium(16))
                    Spacer()
                    Toggle("", isOn: $model.showIndex)
                }
                HStack {
                    Text("Folyamatos olvasás")
                        .font(.medium(16))
                    Spacer()
                    Toggle("", isOn: $model.isTextContinous)
                }
            }
            .padding(.horizontal)
            .padding(.top, 25)            
        }
        .padding(.bottom, 25)
        .background(Color.Theme.light.shadow(radius: 12))        
    }
}

struct TextSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TextSettingsView(model: ReadingTabsViewModel())
            .previewLayout(.sizeThatFits)
    }
}
