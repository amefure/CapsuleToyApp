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
    
}
