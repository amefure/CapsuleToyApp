//
//  LocationRepository.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/11.
//

@preconcurrency
import MapKit
@preconcurrency
import Combine

final class LocationRepository: NSObject, LocationRepositoryProtocol, Sendable {
    
    private let manager = CLLocationManager()
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
    /// 現在位置情報許可ステータス
    public var authorizationStatus: AnyPublisher<CLAuthorizationStatus?, Never> {
        _authorizationStatus.eraseToAnyPublisher()
    }
    private let _authorizationStatus = CurrentValueSubject<CLAuthorizationStatus?, Never>(nil)
    
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
        // 初期値は東京スカイツリーにしておく
        _region.send(Self.defultRegion)
        manager.delegate = self
    }
    
    /// 位置情報を利用許可をリクエスト/
    @MainActor
    public func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    /// ユーザーの位置情報を常に観測するメソッド(未使用)
    @MainActor
    public func observeUserLocation() async {
        // 10メートル単位の精度
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // 更新距離(m)
        manager.distanceFilter = 3.0
        // ユーザーの現在地を監視し追跡をスタートさせるメソッド
        // locationManager(_:didUpdateLocations:)メソッドが呼び出されデリゲートへと情報が譲渡される
        manager.startUpdatingLocation()
        // 現在の位置情報で領域と住所情報を更新
        await reloadRegion()
    }
    
    /// 現在の位置情報で領域と住所情報を更新
    @MainActor
    private func reloadRegion() async {
        guard let location = manager.location else { return }
        let geocoder = CLGeocoder()
        let placemarks = try? await geocoder.reverseGeocodeLocation(location)
        guard let placemark = placemarks?.first else { return }

        // 住所を取得して送信
        fetchAndPostAddress(placemark: placemark)
        // 位置情報領域を送信
        postRegion(location: location)
    }
    
    /// 位置情報領域を送信
    @MainActor
    private func postRegion(location: CLLocation) {
        let center = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: Self.latitudinalMeters,
            longitudinalMeters: Self.longitudinalMeters
        )
        logger.debug("位置情報 緯度：\(region.center.latitude)")
        logger.debug("位置情報 経度：\(region.center.longitude)")
        _region.send(region)
    }
    
    /// 住所を取得して送信
    @MainActor
    private func fetchAndPostAddress(placemark: CLPlacemark) {
        // 住所
        let administrativeArea: String = placemark.administrativeArea ?? ""
        let locality: String = placemark.locality ?? ""
        let subLocality: String = placemark.subLocality ?? ""
        let thoroughfare: String = placemark.thoroughfare ?? ""
        let subThoroughfare: String =  placemark.subThoroughfare ?? ""
        let placeName: String = !thoroughfare.contains(subLocality) ? subLocality + thoroughfare : thoroughfare
        let addless: String = administrativeArea + locality + placeName + subThoroughfare
        logger.debug("住所：\(addless)")
        _address.send(addless)
    }

    /// ジオコーディング　住所 → 座標
    @MainActor
    public func geocode(addressKey: String) async throws {
        let geocoder = CLGeocoder()
        let placemarks: [CLPlacemark] = try await geocoder.geocodeAddressString(addressKey)
        // ジオコーディングできた文字列の場合
        guard let placemark = placemarks.first else { return }
        guard let location = placemark.location else { return }
        // 住所は入力されたものを使用するため不要
        // 住所を取得して送信
        // fetchAndPostAddress(placemark: placemark)
        // 位置情報領域を送信
        postRegion(location: location)
    }
}

extension LocationRepository: CLLocationManagerDelegate {
    
    
    /// ユーザーの現在位置が更新されるたびに呼ばれるデリゲートメソッド
    /// `CLLocationManager.location`にも自動で反映される
    /// `nonisolated`を付与することでMainスレッド以外からも呼び出せるようにする
    /// `delegate`の仕組みがメインスレッドを保証してないため
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print(location)
        logger.debug("現在位置更新")
        Task { @MainActor [weak self] in
            let geocoder = CLGeocoder()
            let placemarks = try? await geocoder.reverseGeocodeLocation(location)
            guard let self else { return }
            guard let placemark = placemarks?.first else { return }
            print(placemark)
            // 住所を取得して送信
            self.fetchAndPostAddress(placemark: placemark)
            // 位置情報領域を送信
            self.postRegion(location: location)
        }
    }
    
    /// 位置情報の利用許可（Authorization Status）に変更があったときに呼ばれるデリゲートメソッド
    /// `nonisolated`を付与することでMainスレッド以外からも呼び出せるようにする
    /// `delegate`の仕組みがメインスレッドを保証してないため
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let guarded = manager.authorizationStatus
        Task { @MainActor [weak self] in
            guard let self else { return }
            self._authorizationStatus.send(guarded)
            // 位置情報が拒否された場合に初期表示位置をセットする
            guard guarded == .denied else {
                logger.debug("位置情報許可ステータス：承認")
                return
            }
            logger.debug("位置情報許可ステータス：拒否")
            self._region.send(Self.defultRegion)
        }
    }
}
