//
//  ExFont.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/02/10.
//

import SwiftUI

/// フォントサイズ
struct FontSize: ViewModifier {
    public let size: CGFloat
    public let bold: Bool
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
            .fontWeight(bold ? .bold : .medium)
    }
}

extension View {
    /// 文字サイズ SSS `Size：10`
    func fontSSS(bold: Bool = false) -> some View {
        modifier(FontSize(size: DeviceSizeUtility.isSESize ? 8 : 10, bold: bold))
    }

    /// 文字サイズ SS `Size：12`
    func fontSS(bold: Bool = false) -> some View {
        modifier(FontSize(size: DeviceSizeUtility.isSESize ? 10 : 12, bold: bold))
    }

    /// 文字サイズ S `Size：14`
    func fontS(bold: Bool = false) -> some View {
        modifier(FontSize(size: DeviceSizeUtility.isSESize ? 12 : 14, bold: bold))
    }

    /// 文字サイズ M `Size：17`
    func fontM(bold: Bool = false) -> some View {
        modifier(FontSize(size: DeviceSizeUtility.isSESize ? 14 : 17, bold: bold))
    }

    /// 文字サイズ L `Size：20`
    func fontL(bold: Bool = false) -> some View {
        modifier(FontSize(size: DeviceSizeUtility.isSESize ? 17 : 20, bold: bold))
    }
    
    /// 文字サイズ LL `Size：24`
    func fontLL(bold: Bool = false) -> some View {
        modifier(FontSize(size: DeviceSizeUtility.isSESize ? 20 : 24, bold: bold))
    }

    /// 文字サイズ カスタム
    func fontCustom(size: CGFloat, bold: Bool = false) -> some View {
        modifier(FontSize(size: size, bold: bold))
    }
}
