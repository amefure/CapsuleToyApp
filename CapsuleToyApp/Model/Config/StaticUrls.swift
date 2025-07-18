//
//  StaticUrls.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/18.
//

final class StaticUrls: Sendable {
    /// アプリURL
    static let APP_URL = "https://apps.apple.com/jp/app/%E3%81%BF%E3%82%93%E3%81%AA%E3%81%AE%E5%87%BA%E7%94%A3%E7%A5%9D%E3%81%84/id6742353345"
    /// レビュー
    static let APP_REVIEW_URL = APP_URL + "?action=write-review"
    /// Webサイトルート
    static let APP_WEB_URL = "https://appdev-room.com/"
    /// コンタクト
    static let APP_CONTACT_URL = APP_WEB_URL + "contact"
    /// 利用規約
    static let APP_TERMS_OF_SERVICE_URL = APP_WEB_URL + "app-terms-of-service"
}
