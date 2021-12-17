// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let bookmark = ImageAsset(name: "Bookmark")
    internal static let camera = ImageAsset(name: "Camera")
    internal static let magnifier = ImageAsset(name: "Magnifier")
    internal static let bookmarkPinkLine = ImageAsset(name: "bookmarkPinkLine")
    internal static let bookmarkBig = ImageAsset(name: "bookmark_big")
    internal static let birdAngry = ImageAsset(name: "bird.angry")
    internal static let birdBlue = ImageAsset(name: "bird.blue")
    internal static let birdHappy = ImageAsset(name: "bird.happy")
    internal static let birdSad = ImageAsset(name: "bird.sad")
    internal static let guide = ImageAsset(name: "Guide")
    internal static let noGuide = ImageAsset(name: "NoGuide")
    internal static let text = ImageAsset(name: "Text")
    internal static let voice = ImageAsset(name: "Voice")
    internal static let reportBackImage = ImageAsset(name: "ReportBackImage")
    internal static let logo = ImageAsset(name: "Logo")
    internal static let splashImage = ImageAsset(name: "SplashImage")
    internal static let baby = ImageAsset(name: "baby")
    internal static let bell = ImageAsset(name: "bell")
    internal static let mainBack = ImageAsset(name: "mainBack")
    internal static let mainBackground = ImageAsset(name: "mainBackground")
    internal static let recommendBtn = ImageAsset(name: "recommendBtn")
    internal static let calendar = ImageAsset(name: "calendar")
    internal static let calendarSelect = ImageAsset(name: "calendar_select")
    internal static let home = ImageAsset(name: "home")
    internal static let homeSelect = ImageAsset(name: "home_select")
    internal static let people = ImageAsset(name: "people")
    internal static let peopleSelect = ImageAsset(name: "people_select")
    internal static let policy = ImageAsset(name: "policy")
    internal static let policySelect = ImageAsset(name: "policy_select")
    internal static let todayBtn = ImageAsset(name: "todayBtn")
    internal static let 로그인 = ImageAsset(name: "로그인")
  }
  internal enum Colors {
    internal static let _45 = ColorAsset(name: "45")
    internal static let _71 = ColorAsset(name: "71")
    internal static let borderYellow = ColorAsset(name: "BorderYellow")
    internal static let pink1 = ColorAsset(name: "Pink1")
    internal static let pink2 = ColorAsset(name: "Pink2")
    internal static let pink3 = ColorAsset(name: "Pink3")
    internal static let pink4 = ColorAsset(name: "Pink4")
    internal static let pink5 = ColorAsset(name: "Pink5")
    internal static let fa = ColorAsset(name: "fa")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
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

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

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
