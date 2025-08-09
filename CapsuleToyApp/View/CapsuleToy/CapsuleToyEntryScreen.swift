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
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    public var seriesId: ObjectId
    public var toy: CapsuleToy?
    
    @State private var name: String = "TOYS"
    @State private var isOwned: Bool = false
    @State private var isSecret: Bool = false
    @State private var memo: String = ""
    @State private var image: UIImage? = nil
    @State private var selectedDate: Date = Date()
    
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
                        image: image,
                        // 所有フラグがONなら日付を登録
                        isGetAt: isOwned ? selectedDate : nil
                    )
                }, content: {
                    Text("ガチャガチャアイテム登録")
                        .fontM(bold: true)
                        .foregroundStyle(.exText)
                }
            )
            
            HStack(alignment: .top) {
                ImageSelectView(image: $image, isDisplayedCropView: true)
                    .environmentObject(rootEnvironment)
                    .padding(.vertical)
                
                VStack {
                    Text("GET")
                        .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                    
                    AnimationCheckButton(isEnable: $isOwned)
                       
                    VStack {
                        if isOwned {
                            Text("GET DATE")
                                .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                            
                            DatePicker(
                                "取得日",
                                selection: $selectedDate,
                                displayedComponents: [.date]
                           ).environment(\.locale, DateFormatUtility.LOCALE)
                                .environment(\.calendar, DateFormatUtility.CALENDAR)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                        }
                        
                        Text("SECRET")
                            .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                        AnimationCheckButton(isEnable: $isSecret, isSecret: true)
                        
                    }.animation(.easeInOut(duration: 0.3), value: isOwned)
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
            selectedDate = toy.isGetAt ?? Date()
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
