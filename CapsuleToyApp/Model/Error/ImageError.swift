//
//  ImageError.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/09.
//

import UIKit

enum ImageError: AppError {
    /// EI001：保存失敗エラー
    case saveFailed

    /// EI002：削除失敗エラー
    case deleteFailed

    /// EI003：型変換失敗エラー(公開しない)
    case castFailed

    public var title: String { L10n.imageErrorTitle }
    
    public var code: String {
        return switch self {
        case .saveFailed:
            L10n.imageError1
        case .deleteFailed:
            L10n.imageError2
        case .castFailed:
            L10n.imageError3
        }
    }

    public var message: String {
        return switch self {
        case .saveFailed:
            L10n.imageErrorSaveFailed
        case .deleteFailed:
            L10n.imageErrorDeleteFailed
        case .castFailed:
            L10n.imageErrorCastFailed
        }
    }
}
