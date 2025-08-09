//
//  ImageSelectView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/09.
//

import SwiftUI

struct ImageSelectView: View {
    
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    @Binding var image: UIImage?
    public let width: CGFloat = DeviceSizeUtility.deviceWidth / 2 - 20
    public let height: CGFloat = DeviceSizeUtility.deviceWidth / 2 - 20
   
    /// 外部からも表示させたくない場合に`true`に操作
    @State var isDisplayedCropView: Bool = false
    
    @State private var showCropView: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var showCameraModal: Bool = false
    
    var body: some View {
        VStack {
            
            Menu {
                Button {
                    isDisplayedCropView = false
                    showImagePicker = true
                } label: {
                    Label("写真から選択する", systemImage: "photo.stack.fill")
                }
                
                Button {
                    isDisplayedCropView = false
                    showCameraModal = true
                } label: {
                    Label("カメラを起動する", systemImage: "camera.fill")
                }

               
            } label: {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .clipped()
                } else {
                    Image(systemName: "plus")
                        .fontM()
                        .foregroundStyle(.exGold)
                        .frame(width: width, height: height)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.exGold, lineWidth: 2)
                        )
                }
            }
            

        }.sheet(isPresented: $showImagePicker) {
            ImagePickerDialog(image: $image)
        }.fullScreenCover(isPresented: $showCameraModal) {
            CameraScreen(image: $image)
                .environmentObject(rootEnvironment)
        }.onChange(of: image) { _,  _ in
            // 1回目の画像の変化で切り取りモーダルを表示していれば2回目は表示しない
            guard !isDisplayedCropView else { return }
            guard image != nil else { return }
            isDisplayedCropView = true
            showCropView = true
        }.fullScreenCover(isPresented: $showCropView) {
            ImageCropDialog(uiImage: $image)
        }
    }
}
