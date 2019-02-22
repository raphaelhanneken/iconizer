//
// Constants.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

// MARK: - Platform names

/// Platform: Apple Watch
@available(*, deprecated)
let appleWatchPlatformName = "Watch"
/// Platform: iPad
@available(*, deprecated)
let iPadPlatformName = "iPad"
/// Platform: iPhone
@available(*, deprecated)
let iPhonePlatformName = "iPhone"
/// Platform: OS X
@available(*, deprecated)
let macOSPlatformName = "Mac"
/// Platform: Car Play
@available(*, deprecated)
let carPlayPlatformName = "Car"
/// Platform: iOS – for icons that are needed on both, iPad and iPhone
@available(*, deprecated)
let iOSPlatformName = "iOS"

// MARK: - Directory names

/// Default url for app icons.
let appIconDir = "Iconizer Assets/App Icons"
/// Default url for launch images.
let launchImageDir = "Iconizer Assets/Launch Images"
/// Default url for image sets.
let imageSetDir = "Iconizer Assets/Image Sets"

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
