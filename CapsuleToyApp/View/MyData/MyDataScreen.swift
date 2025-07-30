//
//  MyDataScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/26.
//

import SwiftUI

struct MyDataScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(MyDataViewModel.self)
    
    var body: some View {
        VStack {
            Text("MyData")
                .fontM(bold: true)
            
            if viewModel.allCount == 0 {
                Spacer()
                Text("データが存在しません。")
                Spacer()
            } else {
                ScrollView {
                    
                    Text("コンプリート率")
                        .exInputLabelView()
                    
                    ParametersView(now: viewModel.completePercent)
                    
                    Text("シークレットゲット率")
                        .exInputLabelView()
                    
                    ParametersView(now: viewModel.getSecretPercent)
                    
                    Text("場所名")
                        .exInputLabelView()
                    ParametersView(now: 80)
                    
                }
            }
        }.onAppear { viewModel.onAppear() }
        
    }
}


private struct ParametersView: View {
    public let now: Double
    /// 100%
    public let max: Double = 100
    public let color: Color = .exText
    public let fullColor: Color = .exGold
    public let width: CGFloat = DeviceSizeUtility.deviceWidth - 80
    public let height: CGFloat = 30
    public let radius: CGFloat = 5

    @State private var target: Double = 0
    @State private var showCapacity: CGFloat = 0

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(now >= max ? "100%" : "\(Int(now))%")
                    .fontM(bold: true)
                    .frame(
                        width: Swift.max(30, width * (min(now, max) / max) + 25),
                        alignment: target == 0 ? .leading : .trailing
                    )
                    .foregroundStyle(target >= max ? fullColor : Asset.Colors.exText.swiftUIColor)
                    .opacity(showCapacity)
                Spacer()
            }.frame(width: width + 20, height: 20)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: radius)
                    .stroke()

                Rectangle()
                    .fill(.gray)
                    .opacity(0.5)
                    .frame(width: 1, height: height - 10)
                    .offset(x: width * 0.25)

                Rectangle()
                    .fill(.gray)
                    .opacity(0.5)
                    .frame(width: 1, height: height - 10)
                    .offset(x: width * 0.5)

                Rectangle()
                    .fill(.gray)
                    .opacity(0.5)
                    .frame(width: 1, height: height - 10)
                    .offset(x: width * 0.75)

                Rectangle()
                    .fill(target >= max ? fullColor : color)
                    .background(Color.gold)
                    .frame(width: width * (min(target, max) / max), height: height)

            }.frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: radius))

            HStack {
                Text("0%")
                    .fontS()

                Spacer()

                Text("\(Int(max))%")
                    .fontS()
            }.frame(width: width + 20, alignment: .leading)

        }.onAppear {
            withAnimation(Animation.linear(duration: 2)) {
                target = now
                showCapacity = 1
            }
        }
    }
}

#Preview {
    MyDataScreen()
}
