//
//  LocationRepository.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/11.
//

import MapKit
import Combine

final class LocationRepository: NSObject, LocationRepositoryProtocol {
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    /// 領域
    public var region: AnyPublisher<MKCoordinateRegion, Never> {
        _region.eraseToAnyPublisher()
    }
    private let _region = CurrentValueSubject<MKCoordinateRegion, Never>(MKCoordinateRegion())
    /// 住所
    public var address: AnyPublisher<String, Never> {
        _address.eraseToAnyPublisher()
    }
    private let _address = CurrentValueSubject<String, Never>("")
    
    static let defultRegion: MKCoordinateRegion = .init(
        center: defaultCenter,
        latitudinalMeters: latitudinalMeters,
        longitudinalMeters: longitudinalMeters
    )
    /// 初期表示位置：東京スカイツリーの場所
    static private let defaultCenter = CLLocationCoordinate2D(
        latitude: 35.709152712026265,
        longitude: 139.80771829999996
    )
    /// 表示メーター
    static private let latitudinalMeters: Double = 1000.0
    static private let longitudinalMeters: Double = 1000.0

    override init() {
        super.init()
        manager.delegate = self
        // 10メートル単位の精度
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // 更新距離(m)
        manager.distanceFilter = 3.0
        manager.startUpdatingLocation()
    }
    
    public func requestWhenInUseAuthorization() {
        // 位置情報を利用許可をリクエスト
        manager.requestWhenInUseAuthorization()
    }
    
    public func reloadRegion() async {
        
        guard let location = manager.location else { return }
        
        let placemarks = try? await geocoder.reverseGeocodeLocation(location)
        guard let placemark = placemarks?.first else { return }
        // 住所
        let administrativeArea: String = placemark.administrativeArea ?? ""
        let locality: String = placemark.locality ?? ""
        let subLocality: String = placemark.subLocality ?? ""
        let thoroughfare: String = placemark.thoroughfare ?? ""
        let subThoroughfare: String =  placemark.subThoroughfare ?? ""
        let placeName: String = !thoroughfare.contains(subLocality) ? subLocality + thoroughfare : thoroughfare
        let addless: String = administrativeArea + locality + placeName + subThoroughfare
        _address.send(addless)
        
        let center = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: Self.latitudinalMeters,
            longitudinalMeters: Self.longitudinalMeters
        )
        _region.send(region)
    }

    /// ジオコーディング　住所 → 座標 InputViewの住所チェック
    public func geocode(addressKey: String) async -> CLLocationCoordinate2D? {
        do {
            let placemarks: [CLPlacemark] = try await geocoder.geocodeAddressString(addressKey)
            // ジオコーディングできた文字列の場合
            guard let location = placemarks.first?.location else { return nil }
            return location.coordinate
        } catch {
            return nil
        }
    }
}

extension LocationRepository: CLLocationManagerDelegate {
    /// 位置情報の利用許可（Authorization Status）に変更があったときに呼ばれるデリゲートメソッド
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let guarded = manager.authorizationStatus.rawValue
        // 位置情報が拒否された場合に初期表示位置をセットする
        guard guarded == 2 else { return }
        _region.send(Self.defultRegion)
    }
}
