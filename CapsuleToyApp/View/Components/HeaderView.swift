//
//  HeaderView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/08.
//

import SwiftUI

struct HeaderView<Content: View>: View {
    
    let leadingIcon: String
    let trailingIcon: String
    let leadingColor: Color
    let trailingColor: Color
    let leadingAction: () -> Void
    let trailingAction: () -> Void
    let content: Content
    
    init(
        leadingIcon: String = "",
        trailingIcon: String = "",
        leadingColor: Color = .exThema,
        trailingColor: Color = .exThema,
        leadingAction: @escaping () -> Void = {},
        trailingAction: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content = { EmptyView() }
    ) {
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.leadingColor = leadingColor
        self.trailingColor = trailingColor
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
        self.content = content()
    }
    
    var body: some View {
        HStack {
            
            if !leadingIcon.isEmpty {
                BoingButton {
                    leadingAction()
                } label: {
                    Image(systemName: leadingIcon)
                        .exCircleButtonView(backgroundColor: leadingColor)
                }
            } else if !trailingIcon.isEmpty {
                Spacer()
                    .frame(width: 40)
            }
            
            Spacer()
            
            content
            
            Spacer()
            
            if !trailingIcon.isEmpty {
                BoingButton {
                    trailingAction()
                } label: {
                    Image(systemName: trailingIcon)
                        .exCircleButtonView(backgroundColor: trailingColor)
                }
                
            } else if !leadingIcon.isEmpty {
                Spacer()
                    .frame(width: 40)
            }
        }.frame(height: 50)
            .foregroundStyle(.exThema)
    }
}

#Preview {
    HeaderView(
        leadingIcon: "swift",
        trailingIcon: "iphone",
        leadingAction: {},
        trailingAction: {},
        content: {}
    )
}


