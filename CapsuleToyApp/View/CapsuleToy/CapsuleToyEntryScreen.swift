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
    public var toy: CapsuleToy?
    
    @State private var name: String = "TOYS"
    @State private var isOwned: Bool = false
    @State private var memo: String = ""
    @State private var image: UIImage? = nil
    
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
                        toyId: toy?.id,
                        name: name,
                        isOwned: isOwned,
                        memo: memo,
                        image: image
                    )
                }
            )
            
            ImageSelectView(image: $image)
                .padding(.vertical)
            
            Text("アイテム名")
                .exInputLabelView()
            TextField("アイテム名", text: $name)
                .exInputBackView()
            
            Toggle(isOn: $isOwned) {
                Text("GET")
            }
            Text("MEMO")
                .exInputLabelView()
            TextEditor(text: $memo)
                .frame(height: 100)
                .exInputBackView()
            
            Spacer()

        }.onAppear {
            guard let toy else { return }
            name = toy.name
            isOwned = toy.isOwned
            memo = toy.memo
            viewModel.onAppear()
        }
        .onDisappear { viewModel.onDisappear() }
        .navigationBarBackButtonHidden()
        .padding()
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
    CapsuleToyEntryScreen(seriesId: ObjectId())
}
