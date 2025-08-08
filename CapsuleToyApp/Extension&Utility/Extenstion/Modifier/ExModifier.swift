//
//  ExModifier.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/01/26.
//

import SwiftUI

struct ThemaButtonView: ViewModifier {
    public let width: CGFloat
    public let foregroundColor: Color
    public let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(foregroundColor)
            .frame(width: width, height: 50)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .gray, radius: 3, x: 4, y: 4)
    }
}

struct InputBackView: ViewModifier {
    public var width: CGFloat = DeviceSizeUtility.deviceWidth - 30
    func body(content: Content) -> some View {
        content
            .padding()
            .tint(.exModeText)
            .foregroundStyle(.exModeText)
            .frame(width: width)
            .background(.exModeBase)
            .fontM(bold: true)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.bottom, 5)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 3, y: 3)
    }
}

struct InputLabelView: ViewModifier {
    public var width: CGFloat = DeviceSizeUtility.deviceWidth - 30
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.exModeText)
            .fontS(bold: true)
            .frame(width: width, alignment: .leading)
            .padding(.top, 5)
    }
}

struct CircleButtonView: ViewModifier {
    
    public let foregroundColor: Color
    public let backgroundColor: Color?
    public let backgroundView: AnyView?
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(foregroundColor)
            .frame(width: 40, height: 40)
            .background(backgroundColor)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .shadow(color: .black.opacity(0.2), radius: 5, x: 3, y: 3)
    }
}

struct LabelView: ViewModifier {
    
    public let isSmall: Bool
    public let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .if(isSmall) { view in
                view
                    .fontS(bold: true)
                    .padding(5)
            }
            .if(!isSmall) { view in
                view
                    .fontM(bold: true)
                    .padding(8)
            }
            .foregroundStyle(.white)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .lineLimit(1)
            .clipped()
            .shadow(color: .black.opacity(0.2), radius: 3, x: 3, y: 3)
            .padding(.vertical, 5)
    }
}

extension View {
    
    /// テーマボタン
    func exThemaButtonView(
        width: CGFloat = DeviceSizeUtility.deviceWidth - 60,
        foregroundColor: Color = .white,
        backgroundColor: Color = .exThema,
    ) -> some View {
        modifier(
            ThemaButtonView(
                width: width,
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor
            )
        )
    }
    
    /// Input要素上に配置するラベル
    func exInputLabelView(
        width: CGFloat? = nil
    ) -> some View {
        if let width = width {
            modifier(InputLabelView(width: width))
        } else {
            modifier(InputLabelView())
        }
    }
    
    /// 白枠入力ボックス背景
    func exInputBackView(
        width: CGFloat? = nil
    ) -> some View {
        if let width = width {
            modifier(InputBackView(width: width))
        } else {
            modifier(InputBackView())
        }
    }
    
    /// サークルボタン
    func exCircleButtonView(
        foregroundColor: Color = .white,
        backgroundColor: Color? = .exThema,
        backgroundView: AnyView? = nil
    ) -> some View {
        modifier(
            CircleButtonView(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                backgroundView: backgroundView
            )
        )
    }
    
    /// テーマラベルビュー
    func exThemaLabelView(
        isSmall: Bool = false,
        backgroundColor: Color
    ) -> some View {
        modifier(
            LabelView(
                isSmall: isSmall,
                backgroundColor: backgroundColor
            )
        )
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
