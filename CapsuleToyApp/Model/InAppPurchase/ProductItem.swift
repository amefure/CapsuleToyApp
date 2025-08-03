//
//  ProductItem.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/02.
//

enum ProductItem {
    case removeAds
    case unlockFeature

    public var id: String {
        return switch self {
        case .removeAds:
            #if DEBUG
                // テスト
                SecretProductIdKey.TEST_REMOVE_ADS
            #else
                // 本番
                SecretProductIdKey.REMOVE_ADS
            #endif
        case .unlockFeature:
            #if DEBUG
                // テスト
                SecretProductIdKey.TEST_UNLOCK_FEATURE
            #else
                // 本番
                SecretProductIdKey.UNLOCK_FEATURE
            #endif
        }
    }

    static func get(id: String) -> ProductItem? {
        switch id {
        case ProductItem.removeAds.id:
            return .removeAds
        case ProductItem.unlockFeature.id:
            return .unlockFeature
        default:
            return nil
        }
    }
}
