//
//  ImageSelectView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/09.
//

import SwiftUI

struct ImageSelectView: View {
    @Binding var image: UIImage?
    public let width: CGFloat = DeviceSizeUtility.deviceWidth / 2 - 20
    public let height: CGFloat = DeviceSizeUtility.deviceWidth / 2 - 20
   
    /// 外部からも表示させたくない場合に`true`に操作
    @State var isDisplayedCropView: Bool = false
    
    @State private var showCropView: Bool = false
    @State private var showImagePicker: Bool = false
    var body: some View {
        VStack {
            if let image {
                Button {
                    isDisplayedCropView = false
                    showImagePicker = true
                } label: {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .clipped()
                }
            } else {
                Button {
                    isDisplayedCropView = false
                    showImagePicker = true
                } label: {
                    Image(systemName: "plus")
                        .fontM()
                        .foregroundStyle(.exThema)
                        .frame(width: width, height: height)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.exThema, lineWidth: 1)
                        )
                }
            }
        }.sheet(isPresented: $showImagePicker) {
            ImagePickerDialog(image: $image)
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
