//
//  ExBoingButton.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/02/09.
//

import SwiftUI

/// ボタン押下時にボヨヨンとするアニメーションボタン
struct BoingButton<Label: View>: View {
    public let action: () -> Void
    public let label: () -> Label

    @State private var isAnimating = false

    var body: some View {
        Button {
            action()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0).delay(0.1)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        } label: {
            label()
                .scaleEffect(isAnimating ? 1.2 : 1.0)
        }
    }
}
