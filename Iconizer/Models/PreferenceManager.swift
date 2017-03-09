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

  var generateAppIconForAppleWatch: Int {
    get { return userDefaults.integer(forKey: generateAppIconForAppleWatchKey) }
    set (newValue) { userDefaults.set(newValue, forKey: generateAppIconForAppleWatchKey) }
  }

  var generateAppIconForIPhone: Int {
    get { return userDefaults.integer(forKey: generateAppIconForIPhoneKey) }
    set (newValue) { userDefaults.set(newValue, forKey: generateAppIconForIPhoneKey) }
  }

  var generateAppIconForIPad: Int {
    get { return userDefaults.integer(forKey: generateAppIconForIPadKey) }
    set (newValue) { userDefaults.set(newValue, forKey: generateAppIconForIPadKey) }
  }

  var generateAppIconForMac: Int {
    get { return userDefaults.integer(forKey: generateAppIconForMacKey) }
    set (newValue) { userDefaults.set(newValue, forKey: generateAppIconForMacKey) }
  }

  var generateAppIconForCar: Int {
    get { return userDefaults.integer(forKey: generateAppIconForCarKey) }
    set (newValue) { userDefaults.set(newValue, forKey: generateAppIconForCarKey) }
  }

  var generateLaunchImageForIPhone: Int {
    get { return userDefaults.integer(forKey: generateLaunchImageForIPhoneKey) }
    set (newValue) { userDefaults.set(newValue, forKey: generateLaunchImageForIPhoneKey) }
  }

  var generateLaunchImageForIPad: Int {
    get { return userDefaults.integer(forKey: generateLaunchImageForIPadKey) }
    set (newValue) { userDefaults.set(newValue, forKey: generateLaunchImageForIPadKey) }
  }

  var combinedAppIconAsset: Int {
    get { return userDefaults.integer(forKey: combinedAppIconAssetKey) }
    set (newValue) { userDefaults.set(newValue, forKey: combinedAppIconAssetKey) }
  }

  var selectedExportType: Int {
    get { return userDefaults.integer(forKey: selectedExportTypeKey) }
    set (newValue) { userDefaults.set(newValue, forKey: selectedExportTypeKey) }
  }

  init() {
    registerDefaultPreferences()
  }

  ///  Register the default preferences.
  func registerDefaultPreferences() {
    let defaults = [generateAppIconForMacKey:        NSOnState,
                    generateAppIconForIPhoneKey:     NSOnState,
                    generateAppIconForIPadKey:       NSOnState,
                    generateAppIconForAppleWatchKey: NSOnState,
                    generateAppIconForCarKey:        NSOnState,
                    generateLaunchImageForIPhoneKey: NSOnState,
                    generateLaunchImageForIPadKey:   NSOnState,
                    combinedAppIconAssetKey:         NSOffState]

    self.userDefaults.register(defaults: defaults)
  }

}
