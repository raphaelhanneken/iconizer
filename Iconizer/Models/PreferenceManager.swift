//
// PreferenceManager.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Raphael Hanneken
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Cocoa


/// Manage the user defaults.
class PreferenceManager {

  /// Holds the standart user defaults.
  private let userDefaults = NSUserDefaults.standardUserDefaults()

  var generateAppIconForAppleWatch: Int {
    get            { return userDefaults.integerForKey(generateAppIconForAppleWatchKey) }
    set (newValue) { userDefaults.setInteger(newValue, forKey: generateAppIconForAppleWatchKey) }
  }

  var generateAppIconForIPhone: Int {
    get            { return userDefaults.integerForKey(generateAppIconForIPhoneKey) }
    set (newValue) { userDefaults.setInteger(newValue, forKey: generateAppIconForIPhoneKey) }
  }

  var generateAppIconForIPad: Int {
    get            { return userDefaults.integerForKey(generateAppIconForIPadKey) }
    set (newValue) { userDefaults.setInteger(newValue, forKey: generateAppIconForIPadKey) }
  }

  var generateAppIconForMac: Int {
    get            { return userDefaults.integerForKey(generateAppIconForMacKey) }
    set (newValue) { userDefaults.setInteger(newValue, forKey: generateAppIconForMacKey) }
  }

  var generateAppIconForCar: Int {
    get            { return userDefaults.integerForKey(generateAppIconForCarKey) }
    set (newValue) { userDefaults.setInteger(newValue, forKey: generateAppIconForCarKey) }
  }

  var generateLaunchImageForIPhone: Int {
    get            { return userDefaults.integerForKey(generateLaunchImageForIPhoneKey) }
    set (newValue) { userDefaults.setInteger(newValue, forKey: generateLaunchImageForIPhoneKey) }
  }

  var generateLaunchImageForIPad: Int {
    get            { return userDefaults.integerForKey(generateLaunchImageForIPadKey) }
    set (newValue) { userDefaults.setInteger(newValue, forKey: generateLaunchImageForIPadKey) }
  }

  var combinedAppIconAsset: Int {
    get            { return userDefaults.integerForKey(combinedAppIconAssetKey) }
    set (newValue) { userDefaults.setInteger(newValue, forKey: combinedAppIconAssetKey) }
  }

  var selectedExportType: Int {
    get            { return userDefaults.integerForKey(selectedExportTypeKey) }
    set (newValue) { userDefaults.setInteger(newValue, forKey: selectedExportTypeKey) }
  }


  init() {
    registerDefaultPreferences()
  }

  ///  Register the default preferences.
  func registerDefaultPreferences() {
    let defaults = [ generateAppIconForMacKey: NSOnState,
      generateAppIconForIPhoneKey: NSOnState,
      generateAppIconForIPadKey: NSOnState,
      generateAppIconForAppleWatchKey: NSOnState,
      generateAppIconForCarKey: NSOnState,
      generateLaunchImageForIPhoneKey: NSOnState,
      generateLaunchImageForIPadKey: NSOnState,
      combinedAppIconAssetKey: NSOffState ]

    self.userDefaults.registerDefaults(defaults)
  }
}