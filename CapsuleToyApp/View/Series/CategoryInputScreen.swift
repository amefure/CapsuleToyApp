//
//  CategoryInputScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/03.
//

import SwiftUI

struct CategoryInputScreen: View {

    @EnvironmentObject var viewModel: SeriesEntryViewModel
    
    @State private var category: Category = Category()
    @State private var name: String = ""
    
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
                    dismiss()
                }
            )
            
            Spacer()
            
            Text("カテゴリ名")
                .exInputLabelView()
               
            
            TextField("例：〇〇", text: $name)
                .exInputBackView()
            
           
            

            Spacer()
        }.onAppear {
            category = Category()
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
    CategoryInputScreen()
}
