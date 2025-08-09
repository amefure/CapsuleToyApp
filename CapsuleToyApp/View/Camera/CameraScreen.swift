//
//  CameraScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/09.
//

import UIKit
import SwiftUI
import Combine

/// カメラ撮影画面
struct CameraScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(CameraScreenViewModel.self)
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    /// 撮影された画像をUIImageに変換して保持
    @Binding var image: UIImage?
    
    /// 写真撮影中
    @State private var isTaking = false
    /// 写真撮影完了変化観測
    @State private var imageTakePublisher: AnyCancellable? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            // カメラのパーミションが拒否されているかどうか
            if !viewModel.disablePermission {
                if let previewLayer = viewModel.previewLayer {
                    CALayerView(caLayer: previewLayer)
                        .onAppear {
                            viewModel.startSession()
                        }.onDisappear {
                            viewModel.endSession()
                        }
                } else {
                    // disablePermissionはアラートフラグにしているためアラート閉じた後falseに戻ってしまう
                    // そのためここが拒否されていた場合に表示されるエリアになる
                    Spacer()
                }
            } else {
                // 初期起動時スペーサー用
                Spacer()
            }
            
            
            HStack {
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(isTaking ? .gray : .white)
                }.frame(width: 40)
                    .padding(.leading, 20)
                
                Spacer()
                
                Button {
                    isTaking = true
                    // 写真を撮影
                    viewModel.takePhoto()
                    // 写真撮影用の遅延
                    sleep(1)
                } label: {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundStyle(isTaking ? .gray : .white)
                        .frame(width: 50, height: 50)
                        .overlay {
                            RoundedRectangle(cornerRadius: 60)
                                .stroke(isTaking ? .gray : .white, lineWidth: 2)
                                .frame(width: 60, height: 60)
                        }.padding(.bottom, 10)
                }.disabled(isTaking)
                
                Spacer()
                
                Spacer()
                    .frame(width: 40)
                    .padding(.trailing, 20)
            }.padding(.bottom)
        }.background(.black)
            .onAppear {
                viewModel.onAppear()
                
                imageTakePublisher = viewModel.$image
                    .sink { image in
                        isTaking = false
                        guard let image else { return }
                        if self.image != nil {
                            // 元画像があるなら明示的に更新する
                            rootEnvironment.redrawPhoto()
                        }
                        self.image = image
                        dismiss()
                }
            }.onDisappear {
                viewModel.onDisappear()
                imageTakePublisher?.cancel()
                imageTakePublisher = nil
            }.alert(
                isPresented: $viewModel.disablePermission,
                title: L10n.dialogNoticeTitle,
                message: L10n.dialogDeniedCameraMsg,
                positiveButtonTitle: L10n.dialogOpenSettingTitle,
                negativeButtonTitle: L10n.cancel,
                positiveAction: {
                    rootEnvironment.openSetiing()
                }
            )
    }
}
