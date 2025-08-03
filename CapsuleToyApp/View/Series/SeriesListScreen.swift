//
//  SeriesListScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import SwiftUI

struct SeriesListScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(SeriesListViewModel.self)
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    @State private var presentEntryScreen: Bool = false
    var body: some View {
        VStack {
            
            HeaderView(
                trailingIcon: "plus",
                trailingAction: {
                    presentEntryScreen = true
                }
            )
            
            List {
                Section {
                    ForEach(viewModel.seriesList) { series in
                        ZStack {
                            NavigationLink {
                                SeriesDetailScreen(seriesId: series.id)
                            } label: {
                                // > アクセサリを非表示にするためZStack + opacity
                            }.opacity(0)
                                .frame(width: 0, height: 0)
                            
                            HStack {
                                
                                ImagePreView(
                                    photoPath: series.imagePath,
                                    width: 60,
                                    height: 60,
                                    isNotView: false,
                                    isEnablePopup: false
                                )
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(series.name)
                                        .fontM(bold: true)
                                        .lineLimit(1)
                                    
                                    Text(series.getFirstCategoryName ?? "未設定")
                                        .fontS(bold: true)
                                        .padding(5)
                                        .foregroundStyle(.white)
                                        .background(.exGold)
                                        .clipShape(RoundedRectangle(cornerRadius: 3))
                                        .lineLimit(1)
                                    
                                    ToysRatingListView(
                                        isOwnedCount: series.isOwendToysCount,
                                        maxCount: series.highCount,
                                        isAnimation: false
                                    )
                                }
                            }
                        }
                    }
                }
                
                if !rootEnvironment.removeAds {
                    Section {
                        AdMobBannerView()
                            .frame(height: 100)
                            .listRowBackground(Color.clear)
                    }
                }
            }
            
                
        }.onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
            .fontM()
            .foregroundStyle(.exText)
            .background(.exFoundation)
            .fullScreenCover(isPresented: $presentEntryScreen) {
                SeriesEntryScreen()
            }
    }
}

#Preview {
    SeriesListScreen()
}
