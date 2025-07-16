//
//  ErrorViewDialog.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/15.
//

import SwiftUI

struct ErrorViewDialog: View {
    
    @Binding var isPresented: Bool
    public var title: String
    public var message: String
    
    /// 表示位置調整用(初期状態は範囲外)
    @State private var offsetY: CGFloat = -200
    
    var body: some View {
        VStack {
            if isPresented {
        
                // ダイアログコンテンツ部分
                VStack(spacing: 10) {
                    Text(title)
                        .fontM(bold: true)
                    
                    Text(message)
                        .fontS()
                        .frame(width: DeviceSizeUtility.deviceWidth - 140, alignment: .leading)
                    
                }.padding(20)
                    .frame(width: DeviceSizeUtility.deviceWidth - 100)
                    .foregroundStyle(.exNegative)
                    .background(.exThemaLight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.exNegative, style: StrokeStyle(lineWidth: 2))
                    }
                    .offset(y: offsetY)
                    .onAppear {
                        // アニメーションで表示
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            offsetY = 0
                        }
                        
                        // 5秒後に非表示にする
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                           withAnimation(.easeInOut(duration: 0.5)) {
                               offsetY = -200 // 上へ移動
                           }
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                               isPresented = false // 完全に非表示にする
                           }
                        }
                    }
                
                Spacer()
                
            }
        }.padding(.top)
    }
}

extension View {
    func overlayErrorViewDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String
    ) -> some View {
        overlay(
            ErrorViewDialog(
                isPresented: isPresented,
                title: title,
                message: message
            )
        )
    }
}

#Preview {
    ErrorViewDialog(
        isPresented: Binding.constant(true),
        title: "title",
        message: "messagemessagemessagemessagemessagemessagemessage"
    )
}
