//
//  ImageFileManager.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/09.
//

import Combine
import SwiftUI
import UIKit

/// アプリからデバイス内(Docmentsフォルダ)へ画像を保存するクラス
final class ImageFileManager: Sendable {

    private let suffix = ".png"

    /// DocmentsフォルダまでのURLを取得
    /// file:///var/mobile/Containers/Data/Application/085DB140-E500-4561-8EA3-A6AF0748AD27/Documents
    /// ↑ 形式で取得できるが`Application/UUID`の`UUID部分はアップデートなどで変わってしまう`ことがあるので
    /// このパスを保存して使用するみたいなことはできないので注意
    private func getDocmentsUrl(_ fileName: String) -> URL? {
        let fileManager = FileManager.default
        guard let docsUrl = try? fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) else { return nil }
        // URLを構築
        let url = docsUrl.appendingPathComponent(fileName)
        return url
    }

    /// 保存した画像を取得
    public func loadImage(_ fileName: String) -> UIImage? {
        let fileManager = FileManager.default
        /// 名前がないなら終了
        guard fileName != "" else { return nil }

        guard let path = getDocmentsUrl("\(fileName + suffix)")?.path else { return nil }
        guard fileManager.fileExists(atPath: path) else { return nil }
        guard let image = UIImage(contentsOfFile: path) else { return nil }
        return image
    }

    /// 保存した画像パスを取得
    public func loadImagePath(_ fileName: String) -> String? {
        let fileManager = FileManager.default
        /// 名前がないなら終了
        guard fileName != "" else { return nil }
        guard let path = getDocmentsUrl("\(fileName + suffix)")?.path else { return nil }
        guard fileManager.fileExists(atPath: path) else { return nil }
        guard UIImage(contentsOfFile: path) != nil else { return nil }
        return path
    }

    /// 画像保存処理
    public func saveImage(name: String, image: UIImage) throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            throw ImageError.castFailed
        }
        guard let path = getDocmentsUrl("\(name + suffix)") else {
            throw ImageError.castFailed
        }
        do {
            try imageData.write(to: path)
            // 保存したパスを返す(ここで返すのはファイル名のみ)
            return name
        } catch {
            throw ImageError.saveFailed
        }
    }

    /// 画像削除処理
    public func deleteImage(name: String) throws {
        let fileManager = FileManager.default
        guard let path = self.getDocmentsUrl("\(name + self.suffix)") else { throw ImageError.castFailed }
        do {
            try fileManager.removeItem(at: path)
        } catch {
            throw ImageError.deleteFailed
        }
    }
}
