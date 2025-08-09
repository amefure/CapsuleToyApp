//
//  CameraFunctionRepository.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/09.
//

import SwiftUI
import AVFoundation
import Combine

final class CameraFunctionRepository: NSObject, @unchecked Sendable {
    
    /// 撮影された写真
    public var image: AnyPublisher<UIImage, Never> {
        _image.eraseToAnyPublisher()
    }
    
    private let _image = PassthroughSubject<UIImage, Never>()
    
    /// 撮影プレビュー領域
    public var previewLayer: AnyPublisher<CALayer, Never> {
        _previewLayer.eraseToAnyPublisher()
    }
    
    private let _previewLayer = PassthroughSubject<CALayer, Never>()
    
    /// カメラ利用許可ステータス
    public var authorizationStatus: AnyPublisher<AVAuthorizationStatus?, Never> {
        _authorizationStatus.eraseToAnyPublisher()
    }
    private let _authorizationStatus = CurrentValueSubject<AVAuthorizationStatus?, Never>(nil)
    
    
    /// 撮影デバイス
    private var capturepDevice: AVCaptureDevice!
    
    private var avSession: AVCaptureSession = AVCaptureSession()
    private var avInput: AVCaptureDeviceInput!
    private var avOutput: AVCapturePhotoOutput!
}

extension CameraFunctionRepository {
    
}

extension CameraFunctionRepository: AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    /// 利用許可申請
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self else { return }
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                logger.debug("カメラ利用：許可済み")
            case .notDetermined:
                logger.debug("カメラ利用：未リクエスト")
            case .denied, .restricted:
                logger.debug("カメラ利用：拒否または制限")
            @unknown default:
                break
            }
            self._authorizationStatus.send(status)
        }
    }
    
    
    ///  初期準備
    public func prepareSetting() {
        requestCameraPermission()
        setUpDevice()
        beginSession()
    }
    
    /// 写真撮影
    public func takePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        // settings.isHighResolutionPhotoEnabled = false
        settings.maxPhotoDimensions = CMVideoDimensions(width: 4032, height: 3024)
        self.avOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    /// セッション開始
    public func startSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            if self.avSession.isRunning { return }
            self.avSession.startRunning()
        }
    }
    
    /// セッション終了
    public func endSession() {
        if !avSession.isRunning { return }
        avSession.stopRunning()
    }
}

extension CameraFunctionRepository {
    
    // 使用するデバイスを取得
    private func setUpDevice() {
        avSession.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
       // capturepDevice = device
        //        if let availableDevice = AVCaptureDevice.DiscoverySession(
        //            deviceTypes: [.builtInWideAngleCamera],
        //            mediaType: AVMediaType.video,
        //            position: .back).devices.first {
        //            capturepDevice = availableDevice
        //        }
    }
    
    // セッションの開始
    private func beginSession() {
        
        self.avSession = AVCaptureSession()
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if self.avSession.canAddInput(deviceInput) {
                self.avSession.addInput(deviceInput)
                self.avInput = deviceInput
                
                let photoOutput = AVCapturePhotoOutput()
                if self.avSession.canAddOutput(photoOutput) {
                    self.avSession.addOutput(photoOutput)
                    self.avOutput = photoOutput
                    
                    let previewLayer = AVCaptureVideoPreviewLayer(session: self.avSession)
                    previewLayer.videoGravity = .resize
                    self._previewLayer.send(previewLayer)
                    
                    self.avSession.sessionPreset = AVCaptureSession.Preset.photo
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    // デリゲートメソッド
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            _image.send(UIImage(data: imageData)!)
        }
    }
}

// カメラプレビュー
struct CALayerView: UIViewControllerRepresentable {
    var caLayer: CALayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CALayerView>) -> UIViewController {
        let viewController = UIViewController()
        // プレビューの大きさを指定 iPhoneのカメラは4:3なのでそれに合わせる
        /// `previewLayer.videoGravity = .resize` を指定することでレイヤーいっぱいに合わせる
        caLayer.frame = CGRect(x: 0, y: 0, width: DeviceSizeUtility.deviceWidth, height: (4 / 3) * DeviceSizeUtility.deviceWidth)
        viewController.view.layer.addSublayer(caLayer)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CALayerView>) {
        // プレビューの大きさを指定 iPhoneのカメラは4:3なのでそれに合わせる
        /// `previewLayer.videoGravity = .resize` を指定することでレイヤーいっぱいに合わせる
        caLayer.frame = CGRect(x: 0, y: 0, width: DeviceSizeUtility.deviceWidth, height: (4 / 3) * DeviceSizeUtility.deviceWidth)
    }
}


