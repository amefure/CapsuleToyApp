//
//  MyDataScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/26.
//

import SwiftUI
import Charts

struct MyDataScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(MyDataViewModel.self)
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    private let df = DateFormatUtility(dateFormat: "M月")
    
    var body: some View {
        ZStack {
            // 機能が購入済みでアンロックされていない && お試し無料閲覧していない
            if rootEnvironment.unlockFeature == false  {
                overLockView()
                    .zIndex(1)
            }
            
            VStack {
                HeaderView(
                    content: {
                        Text("MyData")
                            .fontM(bold: true)
                    }
                )
                
                if viewModel.allCount == 0 {
                    DataEmptyView()
                } else {
                    scrollMyDataView()
                }
            }
        }.onAppear { viewModel.onAppear() }
    }
}

extension MyDataScreen {
    
    private func lockDotLineView() -> some View {
        HStack {
           
            DotLineView()
            
            Spacer()
            
            Image(systemName: "lock.fill")
                .foregroundStyle(.exGold)
                .fontL(bold: true)
            
            Spacer()
            
            DotLineView()
                .rotationEffect(Angle(degrees: 180))
        }.frame(height: 50)
    }
    
    
    private func overLockView() -> some View {
        // 機能解放
        VStack {
            
            lockDotLineView()
                .rotationEffect(Angle(degrees: -15))
            
            Spacer()
            
            ZStack {
                lockDotLineView()
                    .rotationEffect(Angle(degrees: 30))
                
                lockDotLineView()
                    .rotationEffect(Angle(degrees: -30))
                
                VStack {
                    
                    Spacer()
                    
                    Text("MyData機能はロックされています")
                        .fontM(bold: true)
                    
                    Spacer()
                    
                    Text("お試し無料閲覧回数")
                        .fontM()
                        .foregroundStyle(.exText.opacity(0.8))
                        .padding(.bottom)
                    HStack(alignment: .lastTextBaseline) {
                        Text("あと")
                        Text("\(viewModel.limitCount)")
                            .foregroundStyle(.exThema)
                            .fontLL(bold: true)
                        Text("回")
                    }.fontM(bold: true)
                    
                    Spacer()
                    
                    if viewModel.limitCount <= 0 {
                        Button {
                            withAnimation {
                                rootEnvironment.setActiveTab(.settings)
                            }
                        } label: {
                            Text("購入画面へ")
                                .exThemaButtonView(width: 300 - 30)
                        }.buttonStyle(.plain)
                    } else {
                        Button {
                            rootEnvironment.showUnLockMyData()
                        } label: {
                            Text("見てみる")
                                .exThemaButtonView(width: 300 - 30)
                        }.buttonStyle(.plain)
                    }
                    
                }.padding()
                    .frame(width: 300, height: 300)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 3, y: 3)
                
            }
            
                
            Spacer()
            
            lockDotLineView()
                .rotationEffect(Angle(degrees: -15))
            
            Spacer()
            
        }.frame(width: DeviceSizeUtility.deviceWidth)
            .foregroundStyle(.exText)
            .background(.ultraThinMaterial)
    }
    
    
    private func scrollMyDataView() -> some View {
        ScrollView(showsIndicators: false) {
            
            Text("直近6ヶ月の月別購入数")
                .exInputLabelView()
            
            if let dic = viewModel.dayCapsuleToyDictionary() {
                charts(dic: dic)
            } else {
                Text(L10n.mydataNoData)
                    .fontS(bold: true)
                    .foregroundStyle(.exGold)
                    .exInputBackView()
            }
            
            HStack {
                
                sumAmountView()
               
                sumGetCountView()
            }
            
            parametersView(title: "シークレットゲット率", now: viewModel.getSecretPercent)
            
            parametersView(title: "コンプリート率", now: viewModel.completePercent)
            
            
            if !rootEnvironment.removeAds {
                AdMobBannerView()
                    .frame(height: 100)
                    .padding(.top, 30)
            }

        }
    }
    
    private func charts(dic: [Date: [CapsuleToy]]) -> some View {
        Chart {
            ForEach(dic.keys.sorted(by: { $0 < $1 }), id: \.self) { date in
                
                BarMark(
                    x: .value(L10n.mydataChartsX, df.getString(date: date)),
                    y: .value(L10n.mydataChartsY, dic[date]?.count ?? 0)
                ).foregroundStyle(.exThema)
                    .annotation {
                        Text("\(dic[date]?.count ?? 0)")
                            .fontSS(bold: true)
                            .foregroundStyle(.exModeText)
                    }
            }
        }.frame(width: DeviceSizeUtility.deviceWidth - 60 , height: 110)
            .exInputBackView()
    }
    
    private func sumAmountView() -> some View {
        VStack {
            Text("累計購入金額")
                .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
            
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                
                Text("\(viewModel.sumAmount)")
                    .fontL(bold: true)
                    .foregroundStyle(.exThema)
                Text("円")

                   
            }.fontS()
                .exInputBackView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
        }
    }
    
    private func sumGetCountView() -> some View {
        VStack {
            Text("累計獲得種類数")
                .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
            
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                
                Text("\(viewModel.sumGetCount)")
                    .fontL(bold: true)
                    .foregroundStyle(.exThema)
                Text("種")
                
                
            }.fontS()
                .exInputBackView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
        }
    }
    
    private func parametersView(
        title: String,
        now: Double
    ) -> some View {
        VStack {
            Text(title)
                .exInputLabelView()
            
            ParametersView(now: now)
                .exInputBackView()
        }
    }
}



private struct DotLineView: View {
    
    private struct StrokeLine: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
            return path
        }
    }
    
    var body: some View {
        StrokeLine()
            .stroke(
                style: StrokeStyle(
                    lineWidth: 7,       // ドットの太さ
                    lineCap: .round,    // ドットを丸くする
                    dash: [0, 15]       // 0=点の長さ、12=間隔
                )
            )
            .frame(width: DeviceSizeUtility.deviceWidth / 2)
            .foregroundStyle(.exGold)
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
                    .foregroundStyle(target >= max ? fullColor : .exModeText)
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
