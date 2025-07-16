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
class RootEnvironment: ObservableObject {
    
    /// フッタータブ
    @Published var selectedTag: AppTab = .series
    
    /// ダークモードフラグ
    @Published var isDarkMode: Bool = false
    /// 広告削除購入フラグ
    @Published var removeAds: Bool = false
    
    /// 位置情報許可否認状態アラート
    @Published var showLocationDeniedAlert: Bool = false
    
    private let userDefaultsRepository: UserDefaultsRepository
    private let locationRepository: LocationRepositoryProtocol
    
    /// `Combine`
    private var cancellables: Set<AnyCancellable> = []

    init(
        userDefaultsRepository: UserDefaultsRepository,
        locationRepository: LocationRepositoryProtocol
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.locationRepository = locationRepository
        
        // アクティブにしていたタブを反映
        selectedTag = userDefaultsRepository.getActiveTab()
        
        locationRepository.authorizationStatus
            .sink { [weak self] status in
                guard let self else { return }
                guard let status else { return }
                print("status", status.rawValue)
                switch status {
                case .notDetermined:
                    // 位置情報利用の許可がまだユーザーに求められていない状態
                    break
                case .restricted:
                    // 位置情報利用が制限されている状態（ペアレンタルコントロール等による制限）
                    // ユーザー自身で許可できないので設定誘導や代替案を提示する場合がある
                    showLocationDeniedAlert = true
                case .denied:
                    // ユーザーが明示的に位置情報の利用を拒否している状態
                    showLocationDeniedAlert = true
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
    
    @MainActor
    public func onAppear() {
        // 位置情報取得許可申請
        locationRepository.requestWhenInUseAuthorization()
    }
    
    /// アプリの設定画面を開く
    @MainActor
    public func openSetiing() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        guard UIApplication.shared.canOpenURL(settingsURL) else { return }
        UIApplication.shared.open(settingsURL)
    }
}

// MARK: Public Method
extension RootEnvironment {
  
    /// アクティブにしたタブを保存
    public func setActiveTab(_ tab: AppTab) {
        userDefaultsRepository.setActiveTab(tab)
    }
    
}
