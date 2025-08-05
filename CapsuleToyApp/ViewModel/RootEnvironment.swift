//
//  RootEnvironment.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/10.
//

import UIKit
import Combine
import RealmSwift

/// アプリ内で共通で利用される状態や環境値を保持する
final class RootEnvironment: ObservableObject {
    
    /// フッタータブ
    @Published var selectedTag: AppTab = .series
    
    /// ダークモードフラグ
    @Published var isDarkMode: Bool = false
    /// 広告削除購入フラグ
    @Published var removeAds: Bool = false
    /// 機能解放購入フラグ
    @Published var unlockFeature: Bool = false
    
    /// 位置情報許可否認状態アラート
    @Published var showLocationDeniedAlert: Bool = false
    
    /// 位置情報否認アラート表示フラグ(アプリ起動後一回しか表示させない)
    private var isShowDeniedAlert: Bool = false
    
    private let userDefaultsRepository: UserDefaultsRepository
    private let locationRepository: LocationRepositoryProtocol
    private let inAppPurchaseRepository: InAppPurchaseRepository
    
    /// `Combine`
    private var cancellables: Set<AnyCancellable> = []

    init(
        userDefaultsRepository: UserDefaultsRepository,
        locationRepository: LocationRepositoryProtocol,
        inAppPurchaseRepository: InAppPurchaseRepository
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.locationRepository = locationRepository
        self.inAppPurchaseRepository = inAppPurchaseRepository
        
        // フッタータブセットアップ
        setUpTab()
        // アプリ内課金情報を取得&反映
        setPurchasedFlag()
    }
    
    @MainActor
    public func onAppear() {
        // 最初に初期化する
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        // 位置情報取得許可申請
        locationRepository.requestWhenInUseAuthorization()
        
        // アプリ内課金購入状況観測
        sinkPurchasedProducts()
        
        // 位置情報承認状況観測
        sinkLocationAuthorizationStatus()
    }
}

extension RootEnvironment {
    
    /// アクティブにしていたタブを反映
    private func setUpTab() {
        selectedTag = userDefaultsRepository.getActiveTab()
    }
    
    
    /// アプリ内課金情報を取得&反映
    private func setPurchasedFlag() {
        removeAds = userDefaultsRepository.getPurchasedRemoveAds()
        unlockFeature = userDefaultsRepository.getPurchasedUnlockFeature()
    }
    
    /// 位置情報承認状況観測
    private func sinkLocationAuthorizationStatus() {
        locationRepository.authorizationStatus
            .sink { [weak self] status in
                guard let self else { return }
                guard let status else { return }
                switch status {
                case .notDetermined:
                    // 位置情報利用の許可がまだユーザーに求められていない状態
                    break
                case .restricted:
                    // すでに表示ずみなら表示しない
                    guard !isShowDeniedAlert else { return }
                    // 位置情報利用が制限されている状態（ペアレンタルコントロール等による制限）
                    // ユーザー自身で許可できないので設定誘導や代替案を提示する場合がある
                    showLocationDeniedAlert = true
                    isShowDeniedAlert = true
                case .denied:
                    // すでに表示ずみなら表示しない
                    guard !isShowDeniedAlert else { return }
                    // ユーザーが明示的に位置情報の利用を拒否している状態
                    showLocationDeniedAlert = true
                    isShowDeniedAlert = true
                case .authorizedAlways:
                    // 位置情報の利用が常に許可されている状態（バックグラウンド含む）
                    break
                case .authorizedWhenInUse:
                    // アプリ使用中のみ位置情報の利用が許可されている状態
                    break
                @unknown default:
                    // 新しく追加された未対応のステータスが来た場合に備えた保険
                    // ログ出力や例外処理を行うと良い
                    break
                }
            }.store(in: &cancellables)
    }
    
    /// アプリ内課金購入状況観測
    @MainActor
    private func sinkPurchasedProducts() {
        inAppPurchaseRepository.purchasedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                // 購入済みアイテム配列が変化した際に購入済みかどうか確認
                let removeAds = inAppPurchaseRepository.isPurchased(ProductItem.removeAds.id)
                let unlockFeature = inAppPurchaseRepository.isPurchased(ProductItem.unlockFeature.id)
                // 両者trueなら更新
                if removeAds { self.removeAds = true }
                if unlockFeature { self.unlockFeature = true }
            }.store(in: &cancellables)
    }
    
}

// MARK: Public Method
extension RootEnvironment {
  
    /// アクティブにしたタブを保存
    public func setActiveTab(_ tab: AppTab) {
        userDefaultsRepository.setActiveTab(tab)
    }
    
    /// アプリの設定画面を開く
    @MainActor
    public func openSetiing() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        guard UIApplication.shared.canOpenURL(settingsURL) else { return }
        UIApplication.shared.open(settingsURL)
    }
}
