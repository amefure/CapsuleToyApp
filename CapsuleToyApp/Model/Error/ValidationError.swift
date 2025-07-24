//
//  ValidationError.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/21.
//

/// 入力値のバリデーションエラー
enum ValidationError: AppError {
    /// EV001: シリーズ名が未入力です
    case emptySeriesName

    /// EV002: アイテム名が未入力です
    case emptyItemName


    public var title: String { L10n.validationErrorTitle }
    
    public var code: String {
        return switch self {
        case .emptySeriesName:
            L10n.validationError1
        case .emptyItemName:
            L10n.validationError2
        }
    }

    public var message: String {
        return switch self {
        case .emptySeriesName:
            L10n.validationError1Msg
        case .emptyItemName:
            L10n.validationError2Msg
        }
    }
}
