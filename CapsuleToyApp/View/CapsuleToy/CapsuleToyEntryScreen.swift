//
//  CapsuleToyEntryScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/09.
//

import SwiftUI
import RealmSwift

struct CapsuleToyEntryScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(CapsuleToyEntryViewModel.self)
    
    public var seriesId: ObjectId
    public var toyId: ObjectId?
    
    @State private var name: String = "TOYS"
    @State private var isOwned: Bool = false
    @State private var memo: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                trailingIcon: "plus",
                leadingAction: {
                    dismiss()
                },
                trailingAction: {
                    viewModel.createOrUpdateToy(
                        seriesId: seriesId,
                        toyId: toyId,
                        name: name,
                        isOwned: isOwned,
                        memo: memo,
                        image: nil
                    )
                }
            )
            
            Spacer()
            
            TextField("シリーズ名", text: $name)
            
            Toggle(isOn: $isOwned) {
                Text("GET")
            }
            TextField("MEMO", text: $memo)
            
            Spacer()

        }.onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .navigationBarBackButtonHidden()
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
    CapsuleToyEntryScreen(seriesId: ObjectId())
}
