//
//  SettingViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/18.
//

import UIKit
    
final class SettingViewModel: ObservableObject {

    
    /// アプリシェアロジック
    @MainActor
    public func shareApp(shareText: String, shareLink: String) {
        ShareInfoUtillity.shareApp(shareText: shareText, shareLink: shareLink)
    }

    /// バージョン番号取得
    public func getVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
}
