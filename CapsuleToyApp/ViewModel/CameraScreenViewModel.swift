//
//  CameraScreenViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/09.
//

import SwiftUI
import Combine

class CameraScreenViewModel: ObservableObject {
    
    // MARK: - Utility
    private let imageFileManager = ImageFileManager()
    private let dateFormatUtility = DateFormatUtility(dateFormat: "yyyy-MM-dd HH:mm")
    
    @Published var image: UIImage?
    @Published private(set) var previewLayer: CALayer?
    /// カメラ利用許可状態観測(アラート発火)
    @Published var enablePermission: Bool = false
    
    // MARK: - Combine
    private var cancellables: Set<AnyCancellable> = Set()
    
    private var cameraRepository: CameraFunctionRepository
    
    init(cameraRepository: CameraFunctionRepository) {
        self.cameraRepository = cameraRepository
    }
    
    public func onAppear() {
        cameraRepository.image
            .sink { [weak self] image in
                guard let self else { return }
                self.image = image
            }.store(in: &cancellables)
        
        cameraRepository.previewLayer
            .sink { [weak self] previewLayer in
                guard let self else { return }
                self.previewLayer = previewLayer
            }.store(in: &cancellables)
        
        // カメラ利用許可状態観測
        cameraRepository.authorizationStatus
            .sink { [weak self] status in
                guard let self else { return }
                self.enablePermission = status == .authorized
            }.store(in: &cancellables)
        
        cameraRepository.prepareSetting()
       
        startSession()
    }
    
    public func onDisappear() {
        image = nil
        previewLayer = nil
        endSession()
        
        if cancellables.count != 0 {
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        }
    }
}

// MARK: - カメラ機能
extension CameraScreenViewModel {
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
