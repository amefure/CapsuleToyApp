//
//  SeriesDetailScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/08.
//

import SwiftUI
import RealmSwift

struct SeriesDetailScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(SeriesDetailViewModel.self)
    
    public var seriesId: ObjectId

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            if let series = viewModel.series {
                NavigationLink {
                    SeriesEntryScreen(series: series)
                } label: {
                    Text("編集")
                }
                
                BoingButton {
                    viewModel.showConfirmDeleteAlert = true
                } label: {
                    Text(L10n.delete)
                }
                
                Text(series.name)
                Text("\(series.count)")
                Text("\(series.createdAt)")
            }
        }.onAppear { viewModel.onAppear(id: seriesId) }
            .onDisappear { viewModel.onDisappear() }
            .alert(
                isPresented: $viewModel.showConfirmDeleteAlert,
                title: L10n.dialogConfirmTitle,
                message: L10n.dialogDeleteConfirmMsg,
                positiveButtonTitle: L10n.delete,
                negativeButtonTitle: L10n.cancel,
                positiveButtonRole: .destructive,
                negativeButtonRole: .cancel,
                positiveAction: {
                    viewModel.deleteSeries()
                }
            ).alert(
                isPresented: $viewModel.showSuccessDeleteAlert,
                title: L10n.dialogSuccessTitle,
                message: L10n.dialogDeleteMsg,
                positiveButtonTitle: L10n.ok,
                positiveAction: {
                    dismiss()
                }
            ).alert(
                isPresented: $viewModel.showFaieldDeleteAlert,
                title: L10n.dialogErrorTitle,
                message: L10n.dialogDeleteFailedMsg,
                positiveButtonTitle: L10n.ok,
            )
    }
}

#Preview {
    SeriesDetailScreen(seriesId: ObjectId())
}
