//
//  CategoryInputScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/03.
//

import SwiftUI

struct CategoryInputScreen: View {

    @StateObject private var viewModel = DIContainer.shared.resolve(CategoryInputViewModel.self)
    
    @Binding public var categoryDic: [String: Category]
    @State private var name: String = ""
    @State private var selectColor: Color = .exGold
    
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
                    guard let category = viewModel.createCategory(
                        name: name,
                        color: selectColor
                    ) else { return }
                    categoryDic.updateValue(category, forKey: category.id.stringValue)
                    dismiss()
                }
            )
            
            Text("Preview")
                .exInputLabelView()
            
            Text(name.isEmpty ? "カテゴリラベル名" : name)
                .exThemaLabelView(backgroundColor: selectColor)
            
            Text("カテゴリラベル名")
                .exInputLabelView()
               
            TextField("例：〇〇", text: $name)
                .exInputBackView()
            
            Text("ラベルカラー")
                .exInputLabelView()
            ColorPicker("Color Picker", selection: $selectColor)
                  .labelsHidden()

            Spacer()
        }.onAppear {
        }.onDisappear {  }
        .navigationBarBackButtonHidden()
            .fontM()
            .foregroundStyle(.exText)
            .background(.exFoundation)
            .overlayErrorViewDialog(
                isPresented: $viewModel.showValidationErrorAlert,
                title: L10n.dialogErrorTitle,
                message: viewModel.errorMsg
            )
    }
}

#Preview {
    CategoryInputScreen(categoryDic: Binding.constant([:]))
}
