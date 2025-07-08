# 仮 がちゃがちゃMEMO

〇〇なアプリ

## アプリ概要

＼〇〇なアプリ／

◇「アプリ名」でできること
1. 


※ インストール自体は無料ですが一部アプリ内課金要素があります。
- 広告削除機能
- 容量制限解放(無料でも広告を視聴いただくことで容量は増加させることが可能です。)

## 開発環境

- Xcode：16.3
- Swift：6
- Mac M1：Sequoia 15.4

### アーキテクチャ

- MVVM + Repository + Manager
- DI

### 機能一覧

- 

### 自動化
fastlaneを使用してビルドアップロードを自動化しています。

```
$ bundle exec fastlane release
```

Test Flightへのアップロードも自動化しています。

```
$ bundle exec fastlane upload_test_flight
```

### アセット管理
アセットの管理にはSwiftGenを使用しています。以下のコマンドを実行することでアセット管理クラスを自動生成します。

```
$ swiftgen config run
```

## ライブラリ

### ライブラリ管理ツール
Swift Package Manager

### Storage

- RealmSwift・・・アプリ内DB

### Analyze

- FirebaseCrashlytics・・・クラッシュ解析
- FirebaseAnalytics・・・イベント解析
- FirebasePerformance・・・パフォーマンス解析

### Utility

- Google-Mobile-Ads-SDK・・・AdMob 広告表示
- FirebaseRemoteConfig・・・レビューポップアップ表示管理
- CryptoSwift・・・暗号化・複合化 データ送信機能

### Debug
- SwiftFormat/CLI・・・フォーマット
