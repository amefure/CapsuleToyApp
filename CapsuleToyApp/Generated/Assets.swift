
// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let exAccent = ColorAsset(name: "ex_accent")
    internal static let exBlue = ColorAsset(name: "ex_blue")
    internal static let exFoundation = ColorAsset(name: "ex_foundation")
    internal static let exFoundation1 = ColorAsset(name: "ex_foundation_1")
    internal static let exFoundation2 = ColorAsset(name: "ex_foundation_2")
    internal static let exFoundation3 = ColorAsset(name: "ex_foundation_3")
    internal static let exFoundation4 = ColorAsset(name: "ex_foundation_4")
    internal static let exFoundation5 = ColorAsset(name: "ex_foundation_5")
    internal static let exFoundation6 = ColorAsset(name: "ex_foundation_6")
    internal static let exFoundation7 = ColorAsset(name: "ex_foundation_7")
    internal static let exFoundation8 = ColorAsset(name: "ex_foundation_8")
    internal static let exGray = ColorAsset(name: "ex_gray")
    internal static let exGreen = ColorAsset(name: "ex_green")
    internal static let exModeBase = ColorAsset(name: "ex_mode_base")
    internal static let exModeText = ColorAsset(name: "ex_mode_text")
    internal static let exNegative = ColorAsset(name: "ex_negative")
    internal static let exText = ColorAsset(name: "ex_text")
    internal static let exThema = ColorAsset(name: "ex_thema")
    internal static let exThemaLight = ColorAsset(name: "ex_thema_light")
    internal static let exYellow = ColorAsset(name: "ex_yellow")
  }
  internal enum Images {
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset: @unchecked Sendable {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
