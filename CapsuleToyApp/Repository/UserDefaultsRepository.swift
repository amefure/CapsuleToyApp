//
//  UserDefaultsRepository.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import UIKit

class UserDefaultsKey {
    /// アプリ内課金：広告削除
    static let PURCHASED_REMOVE_ADS = "PURCHASE_REMOVE_ADS"
    /// アクティブにしているタブ
    static let ACTIVE_TAB = "ACTIVE_TAB"
}

/// `UserDefaults`の基底クラス
/// スレッドセーフにするため `final class` + `Sendable`準拠
/// `UserDefaults`が`Sendable`ではないがスレッドセーフのため`@unchecked`で無視しておく
final class UserDefaultsRepository: @unchecked Sendable {

    /// `UserDefaults`が`Sendable`ではない
    private let userDefaults: UserDefaults = UserDefaults.standard

    /// Bool：保存
    private func setBoolData(key: String, isOn: Bool) {
        userDefaults.set(isOn, forKey: key)
    }

    /// Bool：取得
    private func getBoolData(key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }

    /// Int：保存
    private func setIntData(key: String, value: Int) {
        userDefaults.set(value, forKey: key)
    }

    /// Int：取得
    private func getIntData(key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }

    /// String：保存
    private func setStringData(key: String, value: String) {
        userDefaults.set(value, forKey: key)
    }

    /// String：取得
    private func getStringData(key: String, initialValue: String = "") -> String {
        return userDefaults.string(forKey: key) ?? initialValue
    }
}

extension UserDefaultsRepository {
    /// `ACTIVE_TAB`
    public func setActiveTab(_ tab: AppTab) {
        setIntData(key: UserDefaultsKey.ACTIVE_TAB, value: tab.rawValue)
    }
    
    /// `ACTIVE_TAB`
    public func getActiveTab() -> AppTab {
        let tab = getIntData(key: UserDefaultsKey.ACTIVE_TAB)
        return AppTab(rawValue: tab) ?? .series
    }
}
