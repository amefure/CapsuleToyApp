//
//  ImageCropDialog.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/09.
//

import SwiftUI
import CoreGraphics

struct ImageCropDialog: View {
    
    /// 切り取りされた画像が格納される
    @Binding var uiImage: UIImage?
    /// オリジナル画像を保持する
    @State private var originalImage: UIImage? = nil
    
    /// トリミングエリア初期形状
    @State private var cropRect: CGRect = CGRect(
        x: DeviceSizeUtility.deviceWidth / 2 - 100,
        y: DeviceSizeUtility.deviceHeight / 2 - 200,
        width: 200,
        height: 200
    )
    
    private let targetWidth: CGFloat = DeviceSizeUtility.deviceWidth
    private let targetHeight: CGFloat = DeviceSizeUtility.deviceHeight - 200
    
    @Environment(\.dismiss) private var dismiss

    /// トリミングエリアの可動域の最大高さ
    private func maxHeight() -> CGFloat {
        guard let uiImage = originalImage else { return targetHeight }
        
        // 画像サイズ(横幅 / 高さ)
        let originalWidth = uiImage.size.width
        let originalHeight = uiImage.size.height
        
        // 縦向き画像(横の方が小さい)なら最大値を領域最大まで
        guard originalWidth > originalHeight else {
            return targetHeight
        }
        // 横向き画像(横の方が大きい)ならアスペクト比で計算した高さの最大まで
        let aspectRatio = originalHeight / originalWidth
        let maxHeight = targetWidth * aspectRatio
        return maxHeight
    }
    
    /// トリミングエリアの可動域の最大横幅
    private func maxWidth() -> CGFloat {
        guard let uiImage = originalImage else { return targetWidth }
        // 画像サイズ(横幅 / 高さ)
        let originalWidth = uiImage.size.width
        let originalHeight = uiImage.size.height
        
        // 横向き画像(横の方が大きい)なら最大値を領域最大まで
        guard originalWidth < originalHeight else {
            return targetWidth
        }
        
        // 縦向き画像(横の方が小さい)ならアスペクト比で計算した横幅の最大まで
        let aspectRatio = originalHeight / originalWidth
        let maxWidth = targetHeight / aspectRatio
        return maxWidth
    }
    
    /// 画像の切り取り処理
    private func cropImage() {
        // 真っ黒背景に対象画像を合成した画像を取得
        guard let scaledImage = compositeImage(in: originalImage) else { return }
        // トリミングエリアの座標を画像の元の座標系に変換(5倍にスケーリング)
        let scaledCropRect = CGRect(
            x: cropRect.origin.x * 5,
            y: cropRect.origin.y * 5,
            width: cropRect.width * 5,
            height: cropRect.height * 5
        )
        
        // トリミング
        guard let cgImage = scaledImage.cgImage?.cropping(to: scaledCropRect) else { return }
        let croppedUIImage = UIImage(cgImage: cgImage)
        uiImage = croppedUIImage
    }
    
    /// 画面と同じアスペクト比で5倍にした真っ黒の画像ベースに
    /// 対象の画像を画面と同じレイアウトで重ねる
    private func compositeImage(in image: UIImage?) -> UIImage? {
        guard let uiImage = image else { return nil }
        
        // 画面幅に合わせたサイズから5倍にスケーリング(画質を担保するため)
        let scalingWidth: CGFloat = targetWidth * 5
        let scalingHeight: CGFloat = targetHeight * 5
        
        // アスペクト比の計算
        let aspectRatio: CGFloat = uiImage.size.width / uiImage.size.height
        
        var targetWidth: CGFloat
        var targetHeight: CGFloat
        
        if uiImage.size.width > uiImage.size.height {
            // 横向き画像
            // 横幅を最大まで
            targetWidth = scalingWidth
            // 高さをアスペクト比を維持した高さまで
            targetHeight = targetWidth / aspectRatio
        } else {
            // 縦向き画像
            // 高さを最大まで
            targetHeight = scalingHeight
            // 横幅をアスペクト比を維持した横幅まで
            targetWidth = targetHeight * aspectRatio
        }
        
        // 画像をスケーリングするためのCGContextを準備
        UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
        uiImage.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        
        // 画面と同じアスペクト比で5倍にした真っ黒の画像ベースを作成
        let backgroundSize: CGSize = CGSize(width: scalingWidth, height: scalingHeight)
        UIGraphicsBeginImageContext(backgroundSize)
        UIColor.black.setFill()
        UIRectFill(CGRect(origin: .zero, size: backgroundSize))
        
        // 真っ黒の画像ベースにスケーリングした画像を中央に配置して描画
        let xOffset: CGFloat = (backgroundSize.width - scaledImage.size.width) / 2
        let yOffset: CGFloat = (backgroundSize.height - scaledImage.size.height) / 2
        scaledImage.draw(in: CGRect(x: xOffset, y: yOffset, width: scaledImage.size.width, height: scaledImage.size.height))
        
        // 合成した画像を取得
        guard let compositeImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        
        return compositeImage
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HeaderView(
                leadingIcon: "xmark",
                trailingIcon: "checkmark",
                leadingAction: {
                    dismiss()
                },
                trailingAction: {
                    cropImage()
                    dismiss()
                },
                content: {
                    Text(L10n.imageClopTitle)
                        .fontL(bold: true)
                        .foregroundStyle(.exModeText)
                }
            )
            
            Spacer()
            
            GeometryReader { geometry in
                ZStack {
                    
                    if let originalImage {
                        // オリジナル画像を表示
                        Image(uiImage: originalImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: targetWidth)
                    }
                   
                    // トリミングエリア
                    // ユーザー視認用
                    Rectangle()
                        .stroke(.exThema, lineWidth: 5)
                        .frame(width: cropRect.width, height: cropRect.height)
                        .position(x: cropRect.midX, y: cropRect.midY)
                    
                    // ユーザーが自由にリサイズ可能な部分
                    resizeEdges(geometry: geometry)
                }
            }.frame(width: targetWidth, height: targetHeight)
           
            Spacer()
           
        }.background(.ultraThinMaterial)
            .onAppear {
                originalImage = uiImage
            }
    }
    
    /// 四角形の縁でリサイズ可能な部分
    private func resizeEdges(geometry: GeometryProxy) -> some View {
        ZStack {
            // 上辺
            Rectangle()
                .fill(.exThema)
                .frame(width: cropRect.width, height: 5)
                .position(x: cropRect.midX, y: cropRect.minY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let deltaY: CGFloat = value.location.y - cropRect.origin.y
                            let max: CGFloat = (targetHeight - maxHeight()) / 2
                            // 上辺が画像の上辺以下にならないように制限
                            if value.location.y > max {
                                cropRect.origin.y = value.location.y
                                cropRect.size.height -= deltaY
                            }
                        }
                )

            // 下辺
            Rectangle()
                .fill(.exThema)
                .frame(width: cropRect.width, height: 5)
                .position(x: cropRect.midX, y: cropRect.maxY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let deltaY: CGFloat = value.location.y - cropRect.maxY
                            let max: CGFloat = (targetHeight / 2) + (maxHeight() / 2)
                            // 下辺が画像の高さ以上にならないように制限
                            if value.location.y < max {
                                cropRect.size.height += deltaY
                            }
                        }
                )

            // 左辺
            Rectangle()
                .fill(.exThema)
                .frame(width: 5, height: cropRect.height)
                .position(x: cropRect.minX, y: cropRect.midY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let deltaX: CGFloat = value.location.x - cropRect.origin.x
                            let max: CGFloat = (targetWidth - maxWidth()) / 2
                            // 左辺が画像の横幅以上にならないように制限
                            if value.location.x > max {
                                cropRect.origin.x = value.location.x
                                cropRect.size.width -= deltaX
                            }
                        }
                )

            // 右辺
            Rectangle()
                .fill(.exThema)
                .frame(width: 5, height: cropRect.height)
                .position(x: cropRect.maxX, y: cropRect.midY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let deltaX: CGFloat = value.location.x - cropRect.maxX
                            let max: CGFloat = (targetWidth / 2) + (maxWidth() / 2)
                            // 右辺が画像の横幅以上にならないように制限
                            if value.location.x < max {
                                cropRect.size.width += deltaX
                            }
                        }
                )
        }
    }

}



#Preview {
    ImageCropDialog(uiImage: Binding.constant(nil))
}
