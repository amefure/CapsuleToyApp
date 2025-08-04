//
//  CategoryInputViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/04.
//

import SwiftUI

final class CategoryInputViewModel: ObservableObject {
    
    @Published var showValidationErrorAlert: Bool = false
    
    @Published private(set) var errorMsg: String = ""
    private var errors: [ValidationError] = []
    
    public func onAppear() { }
    
    public func onDisappear() { }
}

// MARK: - Public Method
extension CategoryInputViewModel {
    
    public func createCategory(
        name: String,
        color: Color
    ) -> Category? {
       
        clearErrorMsg()
        
        if name.isEmpty {
            errors.append(.emptyCategoryName)
        }
        guard errors.isEmpty else {
            showValidationAlert()
            return nil
        }
       
        let category = Category()
        category.name = name
        category.colorHex = color.toHexString()
        return category
    }
}

// MARK: - Private Method
extension CategoryInputViewModel {
    
    private func clearErrorMsg() {
        errors = []
        errorMsg = ""
        showValidationErrorAlert = false
    }
    
    private func showValidationAlert() {
        errorMsg = errors.map { $0.message }.joined(separator: "\n")
        showValidationErrorAlert = true
    }
}
