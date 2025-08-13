//
//  UserDefaultsRepository.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import UIKit

class UserDefaultsKey {
    
    /// アプリアイコン
    static let APP_ICON = "APP_ICON"
    /// ダークモード
    static let IS_DARK_MODE = "IS_DARK_MODE"
    /// アプリ内課金：広告削除
    static let PURCHASED_REMOVE_ADS = "PURCHASE_REMOVE_ADS"
    /// アプリ内課金：機能解放
    static let PURCHASED_UNLOCK_FEATURE = "PURCHASED_UNLOCK_FEATURE"
    /// アクティブにしているタブ
    static let ACTIVE_TAB = "ACTIVE_TAB"
    /// 機能解放ロックリミット
    static let SHOW_LOCK_LIMIT = "SHOW_LOCK_LIMIT"
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
    
    /// `APP_ICON`
    public func setAppIcon(_ icon: AppIcon) {
        setStringData(key: UserDefaultsKey.APP_ICON, value: icon.rawValue)
    }
    
    /// `APP_ICON`
    public func getAppIcon() -> AppIcon {
        let icon = getStringData(key: UserDefaultsKey.APP_ICON, initialValue: AppIcon.red.rawValue)
        return AppIcon(rawValue: icon) ?? .red
        
    }
    
    /// `IS_DARK_MODE`
    public func setIsDarkMode(_ isOn: Bool) {
        setBoolData(key: UserDefaultsKey.IS_DARK_MODE, isOn: isOn)
    }
    
    /// `IS_DARK_MODE`
    public func getIsDarkMode() -> Bool {
        getBoolData(key: UserDefaultsKey.IS_DARK_MODE)
    }
    
    /// `ACTIVE_TAB`
    public func setActiveTab(_ tab: AppTab) {
        setIntData(key: UserDefaultsKey.ACTIVE_TAB, value: tab.rawValue)
    }
    
    /// `ACTIVE_TAB`
    public func getActiveTab() -> AppTab {
        let tab = getIntData(key: UserDefaultsKey.ACTIVE_TAB)
        return AppTab(rawValue: tab) ?? .series
    }
    
    /// `PURCHASED_REMOVE_ADS`
    /// 取得：アプリ内課金 / 広告削除
    public func getPurchasedRemoveAds() -> Bool {
        getBoolData(key: UserDefaultsKey.PURCHASED_REMOVE_ADS)
    }

    /// 登録：アプリ内課金 / 広告削除
    public func setPurchasedRemoveAds(_ flag: Bool) {
        setBoolData(key: UserDefaultsKey.PURCHASED_REMOVE_ADS, isOn: flag)
    }

    /// `PURCHASED_UNLOCK_FEATURE`
    /// 取得：アプリ内課金 / 容量解放
    public func getPurchasedUnlockFeature() -> Bool {
        getBoolData(key: UserDefaultsKey.PURCHASED_UNLOCK_FEATURE)
    }

    /// 登録：アプリ内課金 / 容量解放
    /// 一度`true`になったらアプリからは`false`に戻す処理はない
    public func setPurchasedUnlockFeature(_ flag: Bool) {
        setBoolData(key: UserDefaultsKey.PURCHASED_UNLOCK_FEATURE, isOn: flag)
    }
    
    /// `SHOW_LOCK_LIMIT`
    /// 取得：機能解放ロックリミット
    public func getShowLockLimit() -> Int {
        getIntData(key: UserDefaultsKey.SHOW_LOCK_LIMIT)
    }

    /// 登録：機能解放ロックリミット
    public func incrementShowLockLimit() {
        var current = getShowLockLimit()
        current += 1
        setIntData(key: UserDefaultsKey.SHOW_LOCK_LIMIT, value: current)
    }
}
