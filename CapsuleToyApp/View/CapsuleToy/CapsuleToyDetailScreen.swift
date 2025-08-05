//
//  CapsuleToyDetailScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/26.
//

import SwiftUI
import RealmSwift

struct CapsuleToyDetailScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(CapsuleToyDetailViewModel.self)
    
    private let df = DateFormatUtility()
    
    public var seriesId: ObjectId
    public var toy: CapsuleToy

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HeaderView(
                leadingIcon: "chevron.backward",
                trailingIcon: "square.and.pencil",
                leadingAction: {
                    dismiss()
                },
                trailingAction: {
                    viewModel.presentEntryToyScreen = true
                },
                content: {
                    Text(toy.name)
                        .fontM(bold: true)
                        .lineLimit(2)
                        .foregroundStyle(.exText)
                }
            )
            
            ScrollView(showsIndicators: false) {
                
                HStack(alignment: .top) {
                    ImagePreView(
                        photoPath: toy.imagePath,
                        width: DeviceSizeUtility.deviceWidth / 2 - 20,
                        height: DeviceSizeUtility.deviceWidth / 2 - 20,
                        isNotView: false,
                        isEnablePopup: true
                    ).shadow(color: .black.opacity(0.2), radius: 5, x: 3, y: 3)
                        .padding(.vertical)
                    
                   
                    VStack {
                        Text("GET")
                            .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                        
                        AnimationCheckButton(
                            isEnable: Binding.constant(toy.isOwned),
                            isAppearAnimate: true
                        )
                            
                        if let date = toy.isGetAt {
                            
                            Text("GET DATE")
                                .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                            
                            Text(df.getString(date: date))
                                .fontM(bold: true)
                                .padding(.top, 8)
                        }
                       
                        
                        Text("SECRET")
                            .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                        AnimationCheckButton(
                            isEnable: Binding.constant(toy.isSecret),
                            isAppearAnimate: true,
                            isSecret: true
                        )
                    }
                  
                }
              
                
                if !toy.memo.isEmpty {
                    Text("MEMO")
                        .exInputLabelView()
                    
                    Text("\(toy.memo)")
                        .fontS()
                        .exInputBackView()
                }
              
                Spacer()
                    .frame(height: 40)
                
                Button {
                    viewModel.showConfirmDeleteAlert = true
                } label: {
                    Text("削除する")
                }.frame(width: 200, height: 50)
                    .fontM(bold: true)
                    .foregroundStyle(.exThema)
                    .background(.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 3)
                            .fill(.exThema)
                    }.clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Spacer()
            
            
        }.onAppear {
            viewModel.onAppear(id: seriesId)
        }.onDisappear { viewModel.onDisappear() }
            .navigationBarBackButtonHidden()
            .fontM()
            .foregroundStyle(.exText)
            .background(.exFoundation)
            .navigationDestination(isPresented: $viewModel.presentEntryToyScreen) {
                CapsuleToyEntryScreen(seriesId: seriesId, toy: toy)
            }
            .alert(
                isPresented: $viewModel.showConfirmDeleteAlert,
                title: L10n.dialogConfirmTitle,
                message: L10n.dialogDeleteConfirmMsg,
                positiveButtonTitle: L10n.delete,
                negativeButtonTitle: L10n.cancel,
                positiveButtonRole: .destructive,
                negativeButtonRole: .cancel,
                positiveAction: {
                    viewModel.deleteCapsuleToy(toy)
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
    CapsuleToyDetailScreen(seriesId: ObjectId(), toy: CapsuleToy())
}
