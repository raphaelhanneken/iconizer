//
// PreferenceManager.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Manage the user defaults.
class PreferenceManager {

    /// Holds the standard user defaults.
    private let userDefaults = UserDefaults.standard

    /// Generate app icon set for watchOS?
    var generateAppIconForAppleWatch: Int {
        get { return userDefaults.integer(forKey: Constants.SettingKeys.generateAppIconForAppleWatchKey) }
        set(newValue) { userDefaults.set(newValue, forKey: Constants.SettingKeys.generateAppIconForAppleWatchKey) }
    }

    /// Generate app icon set for iOS (iPhone)?
    var generateAppIconForIPhone: Int {
        get { return userDefaults.integer(forKey: Constants.SettingKeys.generateAppIconForIPhoneKey) }
        set(newValue) { userDefaults.set(newValue, forKey: Constants.SettingKeys.generateAppIconForIPhoneKey) }
    }

    /// Generate app icon set for iOS (iPad)?
    var generateAppIconForIPad: Int {
        get { return userDefaults.integer(forKey: Constants.SettingKeys.generateAppIconForIPadKey) }
        set(newValue) { userDefaults.set(newValue, forKey: Constants.SettingKeys.generateAppIconForIPadKey) }
    }

    /// Generate app icon set for macOS?
    var generateAppIconForMac: Int {
        get { return userDefaults.integer(forKey: Constants.SettingKeys.generateAppIconForMacKey) }
        set(newValue) { userDefaults.set(newValue, forKey: Constants.SettingKeys.generateAppIconForMacKey) }
    }

    /// Generate app icon set for Apple CarPlay?
    var generateAppIconForCar: Int {
        get { return userDefaults.integer(forKey: Constants.SettingKeys.generateAppIconForCarKey) }
        set(newValue) { userDefaults.set(newValue, forKey: Constants.SettingKeys.generateAppIconForCarKey) }
    }

    /// Generate launch image for iPhone?
    var generateLaunchImageForIPhone: Int {
        get { return userDefaults.integer(forKey: Constants.SettingKeys.generateLaunchImageForIPhoneKey) }
        set(newValue) { userDefaults.set(newValue, forKey: Constants.SettingKeys.generateLaunchImageForIPhoneKey) }
    }

    /// Generate launch image for iPad?
    var generateLaunchImageForIPad: Int {
        get { return userDefaults.integer(forKey: Constants.SettingKeys.generateLaunchImageForIPadKey) }
        set(newValue) { userDefaults.set(newValue, forKey: Constants.SettingKeys.generateLaunchImageForIPadKey) }
    }

    /// The selected export type, e.g. App Icon, Launch Image, Icon Set.
    var selectedExportType: Int {
        get { return userDefaults.integer(forKey: Constants.SettingKeys.selectedExportTypeKey) }
        set(newValue) { userDefaults.set(newValue, forKey: Constants.SettingKeys.selectedExportTypeKey) }
    }

    /// Initialize a new PreferenceManager instance.
    init() {
        registerDefaultPreferences()
    }

    ///  Register the default preferences.
    func registerDefaultPreferences() {
        let defaults = [
            Constants.SettingKeys.generateAppIconForMacKey: NSControl.StateValue.on,
            Constants.SettingKeys.generateAppIconForIPhoneKey: NSControl.StateValue.on,
            Constants.SettingKeys.generateAppIconForIPadKey: NSControl.StateValue.on,
            Constants.SettingKeys.generateAppIconForAppleWatchKey: NSControl.StateValue.on,
            Constants.SettingKeys.generateAppIconForCarKey: NSControl.StateValue.on,
            Constants.SettingKeys.generateLaunchImageForIPhoneKey: NSControl.StateValue.on,
            Constants.SettingKeys.generateLaunchImageForIPadKey: NSControl.StateValue.on
        ]

        self.userDefaults.register(defaults: defaults)
    }
}
