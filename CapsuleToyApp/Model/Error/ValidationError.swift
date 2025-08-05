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
    
    /// EV003: カテゴリ名が未入力です
    case emptyCategoryName
    
    /// EV004: 場所名が未入力です
    case emptyLocationName
    
    /// EV005: 種類数が未入力です
    case emptySeriesCount


    public var title: String { L10n.validationErrorTitle }
    
    public var code: String {
        return switch self {
        case .emptySeriesName:
            L10n.validationError1
        case .emptyItemName:
            L10n.validationError2
        case .emptyCategoryName:
            L10n.validationError3
        case .emptyLocationName:
            L10n.validationError4
        case .emptySeriesCount:
            L10n.validationError5
        }
    }

    public var message: String {
        return switch self {
        case .emptySeriesName:
            L10n.validationError1Msg
        case .emptyItemName:
            L10n.validationError2Msg
        case .emptyCategoryName:
            L10n.validationError3Msg
        case .emptyLocationName:
            L10n.validationError4Msg
        case .emptySeriesCount:
            L10n.validationError5Msg
        }
    }
}
