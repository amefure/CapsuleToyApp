//
//  SelectAppIconScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/10.
//

import SwiftUI

struct SelectAppIconScreen: View {
    
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    dismiss()
                },
                content: {
                    Text("アプリアイコン変更")
                        .fontM(bold: true)
                }
            )
            
            Text("アプリアイコンを変更することが可能です。")
                .fontS()
                .padding(.horizontal)
            
            List(AppIcon.allCases, id: \.rawValue) { icon in
                
                Button {
                    rootEnvironment.setAppIcon(icon)
                } label: {
                    HStack {
                        icon.image
                              .resizable()
                              .scaledToFit()
                              .frame(width: 50)
                              .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text(icon.title)
                            .fontM(bold: true)
                        
                        Spacer()
                        
                        if rootEnvironment.currentAppIcon == icon {
                            Image(systemName: "checkmark")
                        }
                    }
                    
                }
            }
               
            Spacer()
        }.fontM()
            .foregroundStyle(.exModeText)
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    SelectAppIconScreen()
}

