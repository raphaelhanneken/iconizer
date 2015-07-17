//
// LaunchImageViewController.swift
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

/// Handles the LaunchImage view.
class LaunchImageViewController: ExportTypeController {
    
    /// Reference to the horizontal image view
    @IBOutlet weak var horizontal: NSImageView!
    
    /// Reference to the portrait image view
    @IBOutlet weak var portrait: NSImageView!
    
    /// Checkbox to export for iPhone
    @IBOutlet weak var iphone: NSButton!
    
    /// Checkbox to export for iPad
    @IBOutlet weak var ipad: NSButton!
    
    /// Returns the selected platforms
    var enabledPlatforms: [String] {
        get {
            var tmp: [String] = []
            
            if iphone.state == NSOnState { tmp.append(kIPhonePlatformName) }
            if ipad.state   == NSOnState { tmp.append(kIPadPlatformName) }
            
            return tmp
        }
    }
    
    /// Holds the LaunchImage model
    let launchImage = LaunchImage()
    
    
    override var nibName: String {
        return "LaunchImageView"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set user defaults.
        let userPrefs     = PreferenceManager()
        self.iphone.state = userPrefs.generateLaunchImageForIPhone
        self.ipad.state   = userPrefs.generateLaunchImageForIPad
    }
    
    override func viewWillDisappear() {
        // Save user defaults.
        let userPrefs = PreferenceManager()
        userPrefs.generateLaunchImageForIPad   = self.ipad.state
        userPrefs.generateLaunchImageForIPhone = self.iphone.state
    }
    
    ///  Tells the model to generate the required images.
    ///
    ///  - returns: True on successful generation, false otherwise.
    override func generateRequiredImages() -> Bool {
        // Verify that both images are available.
        if let landscapeImage = self.horizontal.image, let portraitImage = self.portrait.image {
            // Make sure at least one platform is selected.
            if self.enabledPlatforms.count > 0 {
                // Generate the necessary images.
                if self.launchImage.generateImagesForPlatforms(enabledPlatforms, fromPortrait: portraitImage, andLandscape: landscapeImage) {
                    return true
                }
            } else {
                // No platforms to generate images for.
                beginSheetModalWithMessage("No Platform selected!", andText: "You have to select at least one platform.")
            }
        } else {
            // At least on image is missing!
            beginSheetModalWithMessage("Missing Image!", andText: "You have to provide a landscape and a portrait image.")
        }
        
        return false
    }
    
    ///  Tells the model to save the generated asset catalog to the HD.
    ///
    ///  - parameter url: File URL to save the catalog to.
    override func saveToURL(url: NSURL) {
        self.launchImage.saveAssetCatalogToURL(url)
    }
}
