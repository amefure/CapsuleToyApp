//
//  ImagePreView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/09.
//

import SwiftUI

struct ImagePreView: View {
    public let photoPath: String?
    public let width: CGFloat
    public let height: CGFloat
    public var isNotView: Bool = false
    public var isEnablePopup: Bool = true
    
    private let imageFileManager = ImageFileManager()
    
    @State private var isImagePopupVisible: Bool = false
    
    /// 画像URLを取得
    private func getImageUrl(photoPath: String) -> URL? {
        guard let path = imageFileManager.loadImagePath(photoPath) else { return nil }
        return URL(fileURLWithPath: path)
    }
    
    var body: some View {
        VStack {
            // nil または 空ならNoImage
            if let photoPath, !photoPath.isEmpty {
                
                // ローカルの画像パスを取得
                let imageUrl = getImageUrl(photoPath: photoPath)
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .if(isEnablePopup) { view in
                            view
                                .onTapGesture {
                                    isImagePopupVisible = true
                                }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                } placeholder: {
                    ProgressView()
                        .frame(width: width, height: height)
                        .tint(.exThema)
                        .overlay {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke()
                        }
                }
            } else {
                // 画像がない場合にNoImageを表示したくない場合
                if isNotView {
                    Text("画像なし")
                        .fontL(bold: true)
                        .foregroundStyle(.exText.opacity(0.8))
                        .frame(width: width - 5, height: height)
                } else {
                    Image(systemName: "noimage")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(1.1)
                        .frame(width: width, height: height)
                        .clipped()
                }
            }
        }.fullScreenCover(isPresented: $isImagePopupVisible) {
            // 背景色が透明なモーダルを表示
            FullScreenImageView(imageUrl: getImageUrl(photoPath: photoPath ?? ""))
                .backgroundClearSheet()
        }
    }
}

#Preview {
    ImagePreView(photoPath: "", width: 100, height: 100)
}



/// 画像を全画面表示するビュー
private struct FullScreenImageView: View {
    let imageUrl: URL?
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            ZStack {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
              
                if let imageUrl {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onTapGesture { dismiss() }
                    } placeholder: {
                        ProgressView()
                    }
                }

            }
        }.background(.ultraThinMaterial)
    }
}
