//
//  SeriesEntryScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import SwiftUI

struct SeriesEntryScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(SeriesEntryViewModel.self)
    
    public var series: Series? = nil
    
    @State private var name: String = ""
    @State private var count: String = ""
    @State private var memo: String = ""
    

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            TextField("シリーズ名", text: $name)
            TextField("種類数", text: $count)
                .keyboardType(.numberPad)
            TextField("MEMO", text: $memo)
            
            BoingButton {
                viewModel.createSeriesOrUpdate(
                    id: series?.id,
                    name: name,
                    count: count.toInt() ?? 0,
                    memo: memo
                )
            } label: {
                Image(systemName: "plus")
            }

        }.onAppear {
            guard let series else { return }
            name = series.name
            count = String(series.count)
            memo = series.memo ?? ""
        }
        .onDisappear { viewModel.onDisappear() }
        .alert(
            isPresented: $viewModel.showEntrySuccessAlert,
            title: L10n.dialogSuccessTitle,
            message: L10n.dialogEntryMsg(name),
            positiveButtonTitle: L10n.ok,
            positiveAction: {
                dismiss()
            }
        ).alert(
            isPresented: $viewModel.showUpdateSuccessAlert,
            title: L10n.dialogSuccessTitle,
            message: L10n.dialogUpdateMsg,
            positiveButtonTitle: L10n.ok,
            positiveAction: {
                dismiss()
            }
        )
    }
}

#Preview {
    SeriesEntryScreen()
}
