// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Created by Shibuya
  internal static let appCopyright = L10n.tr("Localizable", "app_copyright", fallback: "Created by Shibuya")
  /// 
  internal static let appFeatures = L10n.tr("Localizable", "app_features", fallback: "")
  /// ガチャガチャ
  internal static let appName = L10n.tr("Localizable", "app_name", fallback: "ガチャガチャ")
  /// Ver %@
  internal static func appVersion(_ p1: Any) -> String {
    return L10n.tr("Localizable", "app_version_%@", String(describing: p1), fallback: "Ver %@")
  }
  /// キャンセル
  internal static let cancel = L10n.tr("Localizable", "cancel", fallback: "キャンセル")
  /// Localizable.strings
  ///   CapsuleToyApp
  /// 
  ///   Created by t&a on 2025/07/08.
  internal static let dateLocale = L10n.tr("Localizable", "date_locale", fallback: "ja_JP")
  /// Asia/Tokyo
  internal static let dateTimezone = L10n.tr("Localizable", "date_timezone", fallback: "Asia/Tokyo")
  /// 削除
  internal static let delete = L10n.tr("Localizable", "delete", fallback: "削除")
  /// 確認
  internal static let dialogConfirmTitle = L10n.tr("Localizable", "dialog_confirm_title", fallback: "確認")
  /// 削除しますか？
  internal static let dialogDeleteConfirmMsg = L10n.tr("Localizable", "dialog_delete_confirm_msg", fallback: "削除しますか？")
  /// 削除に失敗しました。時間を空けてから再度お試しください。
  internal static let dialogDeleteFailedMsg = L10n.tr("Localizable", "dialog_delete_failed_msg", fallback: "削除に失敗しました。時間を空けてから再度お試しください。")
  /// 削除しました。
  internal static let dialogDeleteMsg = L10n.tr("Localizable", "dialog_delete_msg", fallback: "削除しました。")
  /// 位置情報が有効にされていないため一部機能が使用できません。
  internal static let dialogDeniedLocationMsg = L10n.tr("Localizable", "dialog_denied_location_msg", fallback: "位置情報が有効にされていないため一部機能が使用できません。")
  /// 「%@」を登録しました。
  internal static func dialogEntryMsg(_ p1: Any) -> String {
    return L10n.tr("Localizable", "dialog_entry_msg_%@", String(describing: p1), fallback: "「%@」を登録しました。")
  }
  /// Error
  internal static let dialogErrorTitle = L10n.tr("Localizable", "dialog_error_title", fallback: "Error")
  /// お知らせ
  internal static let dialogNoticeTitle = L10n.tr("Localizable", "dialog_notice_title", fallback: "お知らせ")
  /// 設定を開く
  internal static let dialogOpenSettingTitle = L10n.tr("Localizable", "dialog_open_setting_title", fallback: "設定を開く")
  /// 成功
  internal static let dialogSuccessTitle = L10n.tr("Localizable", "dialog_success_title", fallback: "成功")
  /// 更新しました。
  internal static let dialogUpdateMsg = L10n.tr("Localizable", "dialog_update_msg", fallback: "更新しました。")
  /// 登録
  internal static let entry = L10n.tr("Localizable", "entry", fallback: "登録")
  /// 画像トリミング
  internal static let imageClopTitle = L10n.tr("Localizable", "image_clop_title", fallback: "画像トリミング")
  /// EI001
  internal static let imageError1 = L10n.tr("Localizable", "image_error_1", fallback: "EI001")
  /// EI002
  internal static let imageError2 = L10n.tr("Localizable", "image_error_2", fallback: "EI002")
  /// EI003
  internal static let imageError3 = L10n.tr("Localizable", "image_error_3", fallback: "EI003")
  /// 予期せぬエラーが発生しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。
  internal static let imageErrorCastFailed = L10n.tr("Localizable", "image_error_cast_failed", fallback: "予期せぬエラーが発生しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。")
  /// 画像の削除に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。
  internal static let imageErrorDeleteFailed = L10n.tr("Localizable", "image_error_delete_failed", fallback: "画像の削除に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。")
  /// 画像の保存に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。
  internal static let imageErrorSaveFailed = L10n.tr("Localizable", "image_error_save_failed", fallback: "画像の保存に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。")
  /// 画像 Error
  internal static let imageErrorTitle = L10n.tr("Localizable", "image_error_title", fallback: "画像 Error")
  /// 購入する
  internal static let inAppPurchase = L10n.tr("Localizable", "in_app_purchase", fallback: "購入する")
  /// 課金アイテムの取得に失敗しました。
  /// ネットワークの接続を確認してください。
  internal static let inAppPurchaseFetchErrorMsg = L10n.tr("Localizable", "in_app_purchase_fetch_error_msg", fallback: "課金アイテムの取得に失敗しました。\nネットワークの接続を確認してください。")
  /// 購入後のキャンセルは致しかねますのでご了承ください。
  internal static let inAppPurchaseMsg = L10n.tr("Localizable", "in_app_purchase_msg", fallback: "購入後のキャンセルは致しかねますのでご了承ください。")
  /// 復元する
  internal static let inAppPurchaseRestore = L10n.tr("Localizable", "in_app_purchase_restore", fallback: "復元する")
  /// ・一度ご購入いただけますと、
  /// アプリ再インストール時に「復元する」ボタンから
  /// 復元が可能となっています。
  internal static let inAppPurchaseRestoreMsg = L10n.tr("Localizable", "in_app_purchase_restore_msg", fallback: "・一度ご購入いただけますと、\nアプリ再インストール時に「復元する」ボタンから\n復元が可能となっています。")
  /// 購入アイテムを復元する
  internal static let inAppPurchaseRestoreTitle = L10n.tr("Localizable", "in_app_purchase_restore_title", fallback: "購入アイテムを復元する")
  /// 購入済み
  internal static let inAppPurchased = L10n.tr("Localizable", "in_app_purchased", fallback: "購入済み")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok", fallback: "OK")
  /// 送信
  internal static let send = L10n.tr("Localizable", "send", fallback: "送信")
  /// アプリ設定
  internal static let settingSectionApp = L10n.tr("Localizable", "setting_section_app", fallback: "アプリ設定")
  /// よくある質問
  internal static let settingSectionAppFaq = L10n.tr("Localizable", "setting_section_app_faq", fallback: "よくある質問")
  /// ダークモード
  internal static let settingSectionAppMode = L10n.tr("Localizable", "setting_section_app_mode", fallback: "ダークモード")
  /// 広告削除
  internal static let settingSectionAppPurchase = L10n.tr("Localizable", "setting_section_app_purchase", fallback: "広告削除")
  /// アプリの不具合はこちら
  internal static let settingSectionLinkContact = L10n.tr("Localizable", "setting_section_link_contact", fallback: "アプリの不具合はこちら")
  /// ・アプリに不具合がございましたら「アプリの不具合はこちら」よりお問い合わせください。
  internal static let settingSectionLinkDesc = L10n.tr("Localizable", "setting_section_link_desc", fallback: "・アプリに不具合がございましたら「アプリの不具合はこちら」よりお問い合わせください。")
  /// 「アプリ」をオススメする
  internal static let settingSectionLinkRecommend = L10n.tr("Localizable", "setting_section_link_recommend", fallback: "「アプリ」をオススメする")
  /// アプリをレビューする
  internal static let settingSectionLinkReview = L10n.tr("Localizable", "setting_section_link_review", fallback: "アプリをレビューする")
  /// ???????????
  internal static let settingSectionLinkShareText = L10n.tr("Localizable", "setting_section_link_share_text", fallback: "???????????")
  /// 利用規約とプライバシーポリシー
  internal static let settingSectionLinkTerms = L10n.tr("Localizable", "setting_section_link_terms", fallback: "利用規約とプライバシーポリシー")
  /// Link
  internal static let settingSectionLinkTitle = L10n.tr("Localizable", "setting_section_link_title", fallback: "Link")
  /// 未登録
  internal static let unspecified = L10n.tr("Localizable", "unspecified", fallback: "未登録")
  /// 更新
  internal static let update = L10n.tr("Localizable", "update", fallback: "更新")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
