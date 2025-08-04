//
//  ExColor.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/25.
//
import SwiftUI

extension Color {
    /// 金色
    static var gold: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    Color.exGold,
                    Color.exGold,
                    Color.exGold,
                    Color.exGoldLight,
                    Color.exGold,
                    Color.exGold,
                    Color.exGold,
                    Color.exGoldLight,
                    Color.exGold,
                    Color.exGold
                ]
            ),
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
    
    init(hexString: String, alpha: CGFloat = 1.0) {
        // 不要なスペースや改行があれば除去
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // スキャナーオブジェクトの生成
        let scanner = Scanner(string: hexString)

        // 先頭(0番目)が#であれば無視させる
        if (hexString.hasPrefix("#")) {
            scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        }

        var color:Int64 = 0
        // 文字列内から16進数を探索し、Int64型で color変数に格納
        scanner.scanHexInt64(&color)

        let mask:Int = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue,opacity: alpha)
    }
    
    /// 16進数に変換する
    public func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        let cgColor = self.resolve(in: EnvironmentValues()).cgColor
        let uicolor = UIColor(cgColor: cgColor)
        uicolor.getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format:"#%06x", rgb)
    }

}
