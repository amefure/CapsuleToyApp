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
    
    private let userDefaultsRepository: UserDefaultsRepository
    
    /// `Combine`
    private var cancellables: Set<AnyCancellable> = []

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
        
        // アクティブにしていたタブを反映
        selectedTag = userDefaultsRepository.getActiveTab()
    }
    
    public func onAppear() {
       
    }
}

// MARK: Public Method
extension RootEnvironment {
  
    /// アクティブにしたタブを保存
    public func setActiveTab(_ tab: AppTab) {
        userDefaultsRepository.setActiveTab(tab)
    }
    
}
