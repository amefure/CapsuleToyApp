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
    @State private var isSecret: Bool = false
    @State private var memo: String = ""
    @State private var image: UIImage? = nil
    
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
                    viewModel.createOrUpdateToy(
                        seriesId: seriesId,
                        toyId: toy?.id,
                        name: name,
                        isOwned: isOwned,
                        isSecret: isSecret,
                        memo: memo,
                        image: image
                    )
                }
            )
            
            HStack(alignment: .top) {
                ImageSelectView(image: $image, isDisplayedCropView: true)
                    .padding(.vertical)
                
                VStack {
                    Text("所持ずみ")
                        .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                    AnimationCheckButton(isEnable: $isOwned)
                    
                    Text("シークレット")
                        .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                    AnimationCheckButton(isEnable: $isSecret)
                }
            }
            
            Text("アイテム名")
                .exInputLabelView()
            TextField("アイテム名", text: $name)
                .exInputBackView()
            
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
            isSecret = toy.isSecret
            memo = toy.memo
            image = viewModel.fecthImage(id: toy.id.stringValue)
            viewModel.onAppear()
        }
        .onDisappear { viewModel.onDisappear() }
        .navigationBarBackButtonHidden()
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
        ).overlayErrorViewDialog(
            isPresented: $viewModel.showValidationErrorAlert,
            title: L10n.dialogErrorTitle,
            message: viewModel.errorMsg
        )
    }
}

#Preview {
    CapsuleToyEntryScreen(seriesId: ObjectId())
}
