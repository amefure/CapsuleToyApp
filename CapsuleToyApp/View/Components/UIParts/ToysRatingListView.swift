//
//  ToysRatingListView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/10.
//

import SwiftUI

struct ToysRatingListView: View {
    
    public let isOwnedCount: Int
    public let maxCount: Int
    @State private var animatedLevel: Int = 0
    
    private func startAnimate() {
        for i in 0...isOwnedCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 * Double(i)) {
                withAnimation {
                    animatedLevel = i
                }
            }
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<maxCount, id: \.self) { i in
                    Image(systemName: "circle.tophalf.filled")
                        .fontLL(bold: true)
                        .foregroundStyle(
                            animatedLevel >= i ? (i < isOwnedCount ? .exYellow : .exText) : .exText
                        ).animation(
                            .easeOut(duration: 0.3)
                            .delay(0.1 * Double(i)),
                            value: animatedLevel
                        )
                }
            }
        }.onAppear { startAnimate() }
    }
}



#Preview {
    ToysRatingListView(isOwnedCount: 0, maxCount: 0)
}
