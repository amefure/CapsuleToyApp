//
//  SeriesListScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import SwiftUI

struct SeriesListScreen: View {
    @StateObject private var viewModel = DIContainer.shared.resolve(SeriesListViewModel.self)
    var body: some View {
        VStack {
            List(viewModel.seriesList) { series in
                Text(series.name)
            }
        }.onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
    }
}

#Preview {
    SeriesListScreen()
}
