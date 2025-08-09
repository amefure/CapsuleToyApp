//
//  CameraScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/09.
//

import UIKit
import SwiftUI
import Combine

// Beforeカメラ画面
struct CameraScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(CameraScreenViewModel.self)
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    // MARK: - Receive
    @Binding var isRegistering: Bool
    @Binding var isShowCameraView: Bool
    
    // MARK: - View
    @State private var showOnceAgainDialog = false
    @State private var isTaking = false
    @State private var publisher: AnyCancellable? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            
            if viewModel.enablePermission {
                if let previewLayer = viewModel.previewLayer {
                    CALayerView(caLayer: previewLayer)
                        .onAppear {
                            viewModel.startSession()
                        }.onDisappear {
                            viewModel.endSession()
                        }
                }
            } else {
                Spacer()
            }
            
            
            HStack {
                
                Button {
                    if true {
                        // 何も登録されなかったので画面を戻る
                        isShowCameraView = false
                    } else {
                        // 登録終了
                        isRegistering = false
                    }
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
                
                publisher = viewModel.$image
                    .sink { image in
                        guard let image = image else { return isTaking = false }
                       
                }
            }.onDisappear {
                viewModel.onDisappear()
                publisher?.cancel()
            }.alert(
                isPresented: $viewModel.enablePermission,
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
