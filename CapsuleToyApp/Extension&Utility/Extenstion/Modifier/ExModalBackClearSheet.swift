//
//  ExModalBackClearSheet.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/02/19.
//

import SwiftUI

/// モーダル表示するシートの背景色を透明にする
/// https://dev.classmethod.jp/articles/swiftui-mr-transparent/
struct BackgroundClearView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        Task {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
extension View {

    func backgroundClearSheet() -> some View {
        background(BackgroundClearView())
    }
}
