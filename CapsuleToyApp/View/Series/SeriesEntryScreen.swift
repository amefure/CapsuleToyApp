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
    
    @State private var showEntrySuccessAlert: Bool = false
    @State private var showUpdateSuccessAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            TextField("シリーズ名", text: $name)
            TextField("種類数", text: $count)
                .keyboardType(.numberPad)
            TextField("MEMO", text: $memo)
            
            BoingButton {
                
                if let series {
                    viewModel.updateSeries(
                        id: series.id,
                        name: name,
                        count: count.toInt() ?? 0,
                        memo: memo
                    )
                    showUpdateSuccessAlert = true
                } else {
                    viewModel.createSeries(
                        name: name,
                        count: count.toInt() ?? 0,
                        memo: memo
                    )
                    showEntrySuccessAlert = true
                }
                
                
               
            } label: {
                Image(systemName: "plus")
            }

        }.onAppear {
            guard let series else { return }
            name = series.name
            count = String(series.count)
            memo = series.memo ?? ""
        }.alert(
            isPresented: $showEntrySuccessAlert,
            title: "成功",
            message: "「\(name)」を追加しました。",
            positiveButtonTitle: "OK",
            positiveAction: {
                dismiss()
            }
        ).alert(
            isPresented: $showUpdateSuccessAlert,
            title: "成功",
            message: "更新しました。",
            positiveButtonTitle: "OK",
            positiveAction: {
                dismiss()
            }
        )
    }
}

#Preview {
    SeriesEntryScreen()
}
