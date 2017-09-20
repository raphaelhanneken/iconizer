//
// PreferenceManager.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Manage the user defaults.
class PreferenceManager {

    /// Holds the standart user defaults.
    private let userDefaults = UserDefaults.standard

    /// Generate app icon set for watchOS?
    var generateAppIconForAppleWatch: Int {
        get { return userDefaults.integer(forKey: generateAppIconForAppleWatchKey) }
        set(newValue) { userDefaults.set(newValue, forKey: generateAppIconForAppleWatchKey) }
    }

    /// Generate app icon set for iOS (iPhone)?
    var generateAppIconForIPhone: Int {
        get { return userDefaults.integer(forKey: generateAppIconForIPhoneKey) }
        set(newValue) { userDefaults.set(newValue, forKey: generateAppIconForIPhoneKey) }
    }

    /// Generate app icon set for iOS (iPad)?
    var generateAppIconForIPad: Int {
        get { return userDefaults.integer(forKey: generateAppIconForIPadKey) }
        set(newValue) { userDefaults.set(newValue, forKey: generateAppIconForIPadKey) }
    }

    /// Generate app icon set for macOS?
    var generateAppIconForMac: Int {
        get { return userDefaults.integer(forKey: generateAppIconForMacKey) }
        set(newValue) { userDefaults.set(newValue, forKey: generateAppIconForMacKey) }
    }

    /// Generate app icon set for Apple CarPlay?
    var generateAppIconForCar: Int {
        get { return userDefaults.integer(forKey: generateAppIconForCarKey) }
        set(newValue) { userDefaults.set(newValue, forKey: generateAppIconForCarKey) }
    }

    /// Generate launch image for iPhone?
    var generateLaunchImageForIPhone: Int {
        get { return userDefaults.integer(forKey: generateLaunchImageForIPhoneKey) }
        set(newValue) { userDefaults.set(newValue, forKey: generateLaunchImageForIPhoneKey) }
    }

    /// Generate launch image for iPad?
    var generateLaunchImageForIPad: Int {
        get { return userDefaults.integer(forKey: generateLaunchImageForIPadKey) }
        set(newValue) { userDefaults.set(newValue, forKey: generateLaunchImageForIPadKey) }
    }

    /// Generate the app icon sets as a single combined xcasset?
    var combinedAppIconAsset: Int {
        get { return userDefaults.integer(forKey: combinedAppIconAssetKey) }
        set(newValue) { userDefaults.set(newValue, forKey: combinedAppIconAssetKey) }
    }

    /// The selected export type, e.g. App Icon, Launch Image, Icon Set.
    var selectedExportType: Int {
        get { return userDefaults.integer(forKey: selectedExportTypeKey) }
        set(newValue) { userDefaults.set(newValue, forKey: selectedExportTypeKey) }
    }

    /// Initialize a new PreferenceManager instance.
    init() {
        registerDefaultPreferences()
    }

    ///  Register the default preferences.
    func registerDefaultPreferences() {
        let defaults = [
            generateAppIconForMacKey: NSControl.StateValue.on,
            generateAppIconForIPhoneKey: NSControl.StateValue.on,
            generateAppIconForIPadKey: NSControl.StateValue.on,
            generateAppIconForAppleWatchKey: NSControl.StateValue.on,
            generateAppIconForCarKey: NSControl.StateValue.on,
            generateLaunchImageForIPhoneKey: NSControl.StateValue.on,
            generateLaunchImageForIPadKey: NSControl.StateValue.on,
            combinedAppIconAssetKey: NSControl.StateValue.off
        ]

        self.userDefaults.register(defaults: defaults)
    }
}
