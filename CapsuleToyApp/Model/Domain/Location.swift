//
//  Location.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/11.
//

import Foundation
import RealmSwift
import MapKit

/// ロケーション情報
final class Location: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    /// 名称
    @Persisted var name: String
    /// 緯度
    @Persisted var latitude: Double?
    /// 経度
    @Persisted var longitude: Double?
    /// MEMO
    @Persisted var memo: String
}

extension Location {
    /// 緯度 / 経度から位置情報を生成
    public var coordinate: CLLocationCoordinate2D? {
        guard let latitude,
              let longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
