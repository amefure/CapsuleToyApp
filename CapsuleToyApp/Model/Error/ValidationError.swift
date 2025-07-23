//
//  ValidationError.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/21.
//

/// 入力値のバリデーションエラー
enum ValidationError: AppError {
    /// EV001: 名称が未入力です
    case emptyName

    /// EV002: 


    public var title: String { L10n.imageErrorTitle }
    
    public var code: String {
        return switch self {
        case .emptyName:
            L10n.imageError1
        }
    }

    public var message: String {
        return switch self {
        case .emptyName:
            L10n.imageErrorSaveFailed
        }
    }
}
