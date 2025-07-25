//
//  AnimationCheckButton.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/19.
//

import SwiftUI

struct AnimationCheckButton: View {
    /// チェック済み有効かどうか
    @Binding var isEnable: Bool
    /// ボタン機能ではなくView表示時にアニメーションを実行するかどうか
    public var isAppearAnimate: Bool = false
    /// シークレットかどうか
    public var isSecret: Bool = false
    public var action: (() -> Void)? = nil
    
    @State private var drawProgress: CGFloat = 0.0
    
   
    var body: some View {
        BoingButton {
            action?()
            if !isAppearAnimate {
                isEnable.toggle()
                withAnimation(.easeInOut) {
                    if drawProgress == 0.0 {
                        drawProgress = 1.0
                    } else {
                        drawProgress = 0.0
                    }
                }
            }
        } label: {
            ZStack {
                // アニメーションチェックマーク用
                AnimatedCheckMarkView(drawProgress: $drawProgress)
                // プレースホルダー用
                AnimatedCheckMarkView(drawProgress: Binding.constant(1), color: .white.opacity(0.2))
            }
        }.exCircleButtonView(
            backgroundColor: isSecret ? isEnable ? nil : .exText : isEnable ? .exThema : .exText,
            backgroundView: isSecret ? isEnable ? AnyView(Color.gold) : nil : nil
        ).onAppear {
            if isEnable {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeInOut) {
                        drawProgress = 1.0
                    }
                }
            }
        }.onDisappear {
            if isAppearAnimate && isEnable {
                drawProgress = 0.0
            }
        }
    }
}



struct AnimatedCheckMarkView: View {
    @Binding var drawProgress: CGFloat
    public var color: Color = .white
    public var size: CGFloat = 30
    public var lineWidth: CGFloat = 4

    var body: some View {
        CheckMarkShape()
            .trim(from: 0, to: drawProgress)
            .stroke(color, lineWidth: lineWidth)
            .frame(width: size, height: size)
            .animation(.easeIn(duration: 0.4), value: drawProgress)
    }
}

private struct CheckMarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startPoint = CGPoint(x: rect.width * 0.2, y: rect.height * 0.5)
        let midPoint = CGPoint(x: rect.width * 0.4, y: rect.height * 0.7)
        let endPoint = CGPoint(x: rect.width * 0.8, y: rect.height * 0.3)

        path.move(to: startPoint)
        path.addLine(to: midPoint)
        path.addLine(to: endPoint)

        return path
    }
}

