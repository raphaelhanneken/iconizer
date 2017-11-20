//
// Constants.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

///  Nicely wrap up the integers from the NSSegmentedControl.
///
///  - appIconViewControllerTag:     Represents the tag for the AppIconView.
///  - launchImageViewControllerTag: Represents the tag for the LaunchImageView.
///  - imageSetViewControllerTag:    Represents the tag for the ImageSetView.
///  - iMessageViewControllerTag:    Represents the tag for the IMessageView.
enum ViewControllerTag: Int {
    case appIconViewControllerTag = 0
    case launchImageViewControllerTag = 1
    case imageSetViewControllerTag = 2
    case iMessageViewControllerTag = 3
}

// MARK: - Platform names

/// Platform: Apple Watch
let appleWatchPlatformName = "Watch"
/// Platform: iPad
let iPadPlatformName = "iPad"
/// Platform: iPhone
let iPhonePlatformName = "iPhone"
/// Platform: OS X
let macOSPlatformName = "Mac"
/// Platform: Car Play
let carPlayPlatformName = "Car"

// MARK: - Image Orientation names

///  Possible image orientations.
///
///  - Portrait:  Portrait image.
///  - Landscape: Landscape image.
enum ImageOrientation: String {
    case portrait
    case landscape
}

// MARK: - Directory names

/// Default url for app icons.
let appIconDir = "Iconizer Assets/App Icons"
/// Default url for launch images.
let launchImageDir = "Iconizer Assets/Launch Images"
/// Default url for image sets.
let imageSetDir = "Iconizer Assets/Image Sets"
/// Default url for iMessage icons.
let iMessageDir = "Iconizer Assets/iMessage Icons"

// MARK: - Asset Types

///  Nicely wrap the different asset types into an enum.
///
///  - AppIcon:     Represents the AppIcon model
///  - ImageSet:    Represents the ImageSet model
///  - LaunchImage: Represents the LaunchImage model
///  - iMessage: Represents the IMessageIcon model
enum AssetType: Int {
    case appIcon = 0
    case imageSet = 1
    case launchImage = 2
}

// MARK: - Keys to access the user defaults

/// Generate an AppIcon for the Apple Watch.
let generateAppIconForAppleWatchKey = "generateAppIconForAppleWatch"
/// Generate an AppIcon for the iPhone.
let generateAppIconForIPhoneKey = "generateAppIconForIPhone"
/// Generate an AppIcon for the iPad.
let generateAppIconForIPadKey = "generateAppIconForIPad"
/// Generate an AppIcon for OS X.
let generateAppIconForMacKey = "generateAppIconForMac"
/// Generate an AppIcon for CarPlay
let generateAppIconForCarKey = "generateAppIconForCar"
/// Generate an AppIcon with multiple platforms (combined asset)
let combinedAppIconAssetKey = "combinedAppIconAsset"
/// Selected ExportTypeViewController (NSSegmentedControl)
let selectedExportTypeKey = "selectedExportType"
/// Generate a LaunchImage for the iPhone.
let generateLaunchImageForIPhoneKey = "generateLaunchImageForIPhone"
/// Generate a LaunchImage for the iPad.
let generateLaunchImageForIPadKey = "generateLaunchImageForIPad"
