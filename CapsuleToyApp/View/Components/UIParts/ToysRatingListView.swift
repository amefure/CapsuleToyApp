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
    public var isAnimation: Bool = true
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
                        .if(!isAnimation) { view in
                            view
                                .fontM(bold: true)
                        }.if(isAnimation) { view in
                            view
                                .fontLL(bold: true)
                        }
                        .foregroundStyle(
                            animatedLevel >= i ? (i < isOwnedCount ? .exThema : .exThema.opacity(0.2)) : .exThema.opacity(0.2)
                        ).animation(
                            .easeOut(duration: 0.3)
                            .delay(0.1 * Double(i)),
                            value: animatedLevel
                        )
                }
            }
        }.onAppear {
            if isAnimation {
                startAnimate()
            } else {
                animatedLevel = isOwnedCount
            }
        }
    }
}



#Preview {
    ToysRatingListView(isOwnedCount: 0, maxCount: 0)
}
