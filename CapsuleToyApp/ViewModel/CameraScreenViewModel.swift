//
//  CameraScreenViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/09.
//

import SwiftUI
import Combine

class CameraScreenViewModel: ObservableObject {
    
    @Published var image: UIImage?
    /// カメラプレビュー領域
    @Published private(set) var previewLayer: CALayer?
    /// カメラ利用許可状態観測(アラート発火)
    @Published var disablePermission: Bool = false
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    private var cameraRepository: CameraFunctionRepository
    
    init(cameraRepository: CameraFunctionRepository) {
        self.cameraRepository = cameraRepository
    }
    
    public func onAppear() {
        
        observeCameraFunction()
        
        cameraRepository.prepareSetting()
       
        startSession()
    }
    
    public func onDisappear() {
        image = nil
        previewLayer = nil
        endSession()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

// MARK: - カメラ機能
extension CameraScreenViewModel {

    /// カメラ周りの観測処理
    private func observeCameraFunction() {
        // 撮影された画像
        cameraRepository.image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self else { return }
                self.image = image
            }.store(in: &cancellables)
        
        // カメラプレビュー領域
        cameraRepository.previewLayer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] previewLayer in
                guard let self else { return }
                self.previewLayer = previewLayer
            }.store(in: &cancellables)
        
        // カメラ利用許可状態観測
        cameraRepository.authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                self.disablePermission = status != .authorized
            }.store(in: &cancellables)
    }
    
    /// 写真撮影
    public func takePhoto() {
        cameraRepository.takePhoto()
    }
    /// セッション開始
    public func startSession() {
        cameraRepository.startSession()
    }
    /// セッション終了
    public func endSession() {
        cameraRepository.endSession()
    }
}
