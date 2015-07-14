//
// PreferenceManager.swift
// Iconizer
// https://github.com/behoernchen/Iconizer
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


/// Manage the user default settings.
class PreferenceManager {
    
     /// Holds the standart user defaults.
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var generateForAppleWatch: Int {
        get            { return userDefaults.integerForKey(generateForAppleWatchKey) }
        set (newValue) { userDefaults.setInteger(newValue, forKey: generateForAppleWatchKey) }
    }
    
    var generateForIPhone: Int {
        get            { return userDefaults.integerForKey(generateForIPhoneKey) }
        set (newValue) { userDefaults.setInteger(newValue, forKey: generateForIPhoneKey) }
    }
    
    var generateForIPad: Int {
        get            { return userDefaults.integerForKey(generateForIPadKey) }
        set (newValue) { userDefaults.setInteger(newValue, forKey: generateForIPadKey) }
    }
    
    var generateForMac: Int {
        get            { return userDefaults.integerForKey(generateForMacKey) }
        set (newValue) { userDefaults.setInteger(newValue, forKey: generateForMacKey) }
    }
    
    var generateForCar: Int {
        get            { return userDefaults.integerForKey(generateForCarKey) }
        set (newValue) { userDefaults.setInteger(newValue, forKey: generateForCarKey) }
    }
    
    var combinedAsset: Int {
        get            { return userDefaults.integerForKey(combinedAssetKey) }
        set (newValue) { userDefaults.setInteger(newValue, forKey: combinedAssetKey) }
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
        let defaults = [ generateForMacKey: NSOnState,
                         generateForIPhoneKey: NSOnState,
                         generateForIPadKey: NSOnState,
                         generateForAppleWatchKey: NSOnState,
                         generateForCarKey: NSOnState,
                         combinedAssetKey: NSOffState ]
        
        self.userDefaults.registerDefaults(defaults)
    }
}