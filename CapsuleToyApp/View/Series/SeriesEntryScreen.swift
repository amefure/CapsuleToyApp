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
    @State private var amount: String = ""
    @State private var memo: String = ""
    

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                trailingIcon: "checkmark",
                leadingAction: {
                    dismiss()
                },
                trailingAction: {
                    viewModel.createOrUpdateSeries(
                        id: series?.id,
                        name: name,
                        count: count.toInt() ?? 0,
                        amount: amount.toInt() ?? 0,
                        memo: memo
                    )
                }
            )
            
            Text("シリーズ名")
                .exInputLabelView()
            TextField("例：△△シリーズ", text: $name)
                .exInputBackView()
            
            Text("種類数")
                .exInputLabelView()
           
            HStack(alignment: .bottom) {
                TextField("例：6種類", text: $count)
                    .keyboardType(.numberPad)
                Text("／種類")
                    .fontS(bold: true)
                    .opacity(0.5)
            }.exInputBackView()
            
            Text("金額")
                .exInputLabelView()
            
            HStack(alignment: .bottom) {
                TextField("例：300円", text: $amount)
                    .keyboardType(.numberPad)
                Text("／円")
                    .fontS(bold: true)
                    .opacity(0.5)
            }.exInputBackView()
            
            Text("MEMO")
                .exInputLabelView()
            TextEditor(text: $memo)
                .frame(height: 100)
                .exInputBackView()
            
            Spacer()

        }.onAppear {
            guard let series else { return }
            name = series.name
            count = String(series.count)
            amount = String(series.amount)
            memo = series.memo
        }
        .onDisappear { viewModel.onDisappear() }
        .navigationBarBackButtonHidden()
        .padding(.horizontal)
        .fontM()
        .foregroundStyle(.exText)
        .background(.exFoundation)
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
