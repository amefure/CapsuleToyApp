//
//  SeriesListScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import SwiftUI

struct SeriesListScreen: View {
    @StateObject private var viewModel = DIContainer.shared.resolve(SeriesListViewModel.self)
    
    @State private var presentEntryScreen: Bool = false
    var body: some View {
        VStack {
            
            HeaderView(
                trailingIcon: "plus",
                trailingAction: {
                    presentEntryScreen = true
                }
            ).padding(.horizontal)
            
            List(viewModel.seriesList) { series in
                NavigationLink {
                    SeriesDetailScreen(seriesId: series.id)
                } label: {
                    HStack(alignment: .bottom) {
                        Image(systemName: "circle.tophalf.filled")
                            .foregroundStyle(.accent)
                        
                        Text(series.name)
                            .fontM(bold: true)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        HStack(spacing: 5) {
                            Text("\(series.isOwendToysCount)")
                                .fontS(bold: true)
                            
                            Text("／")
                                .fontS(bold: true)
                            
                            Text("\(series.count)")
                                .fontS(bold: true)
                        }.foregroundStyle(series.isComplete ? .accent : .exText)
                       
                    }
                }.frame(height: 60)
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
