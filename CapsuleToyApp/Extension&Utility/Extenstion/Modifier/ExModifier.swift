//
//  ExModifier.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/01/26.
//

import SwiftUI

struct CircleButtonView: ViewModifier {
    
    public let foregroundColor: Color
    public let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(foregroundColor)
            .frame(width: 40, height: 40)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .shadow(color: .black.opacity(0.2), radius: 5, x: 3, y: 3)
    }
}

extension View {
    
    /// サークルボタン
    func exCircleButtonView(
        foregroundColor: Color = .white,
        backgroundColor: Color = .exThema
    ) -> some View {
        modifier(CircleButtonView(foregroundColor: foregroundColor, backgroundColor: backgroundColor))
    }

}

extension View {
    /// モディファイアをif文で分岐して有効/無効を切り替えることができる拡張
    ///
    /// - Parameters:
    ///   - condition: 有効/無効の条件
    ///   - apply: 有効時に適応させたいモディファイア

    /// Example:
    /// ```
    /// .if(condition) { view in
    ///     view.foregroundStyle(.green)
    /// }
    /// ```
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, apply: (Self) -> Content) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
}
