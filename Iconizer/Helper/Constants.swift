//
// Constants.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

struct Constants {
    // MARK: - Directory names
    struct Directory {
        static let root = "Iconizer Assets"
        static let appIcon = root + "/App Icons"
        static let launchImage = root + "/Launch Images"
        static let imageSet = root + "/Image Sets"
    }

    // MARK: - Keys to access the user defaults
    struct SettingKeys {
        /// Generate an AppIcon for the Apple Watch.
        static let generateAppIconForAppleWatchKey = "generateAppIconForAppleWatch"
        /// Generate an AppIcon for the iPhone.
        static let generateAppIconForIPhoneKey = "generateAppIconForIPhone"
        /// Generate an AppIcon for the iPad.
        static let generateAppIconForIPadKey = "generateAppIconForIPad"
        /// Generate an AppIcon for OS X.
        static let generateAppIconForMacKey = "generateAppIconForMac"
        /// Generate an AppIcon for CarPlay
        static let generateAppIconForCarKey = "generateAppIconForCar"
        /// Selected ExportTypeViewController (NSSegmentedControl)
        static let selectedExportTypeKey = "selectedExportType"
        /// Generate a LaunchImage for the iPhone.
        static let generateLaunchImageForIPhoneKey = "generateLaunchImageForIPhone"
        /// Generate a LaunchImage for the iPad.
        static let generateLaunchImageForIPadKey = "generateLaunchImageForIPad"
    }
}
