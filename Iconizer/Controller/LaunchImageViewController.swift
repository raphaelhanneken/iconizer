//
// LaunchImageViewController.swift
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

/// Handles the LaunchImage view.
class LaunchImageViewController: NSViewController {

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

  /// Name of the corresponding nib file.
  override var nibName: String {
    return "LaunchImageView"
  }


  // MARK: View Controller

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set user defaults.
    let userPrefs     = PreferenceManager()
    self.iphone.state = userPrefs.generateLaunchImageForIPhone
    self.ipad.state   = userPrefs.generateLaunchImageForIPad
  }

  override func viewWillDisappear() {
    // Save user defaults.
    let userPrefs                          = PreferenceManager()
    userPrefs.generateLaunchImageForIPad   = self.ipad.state
    userPrefs.generateLaunchImageForIPhone = self.iphone.state
  }


  // MARK: Methods

  ///  Generates the necessary images.
  ///
  ///  - throws: A LaunchImageError.
  override func generateRequiredImages() throws {
    // Verify that both images are available.
    guard let landscapeImage = horizontal.image, let portraitImage = portrait.image else {
      // At least on image is missing!
      beginSheetModalWithMessage("Missing Image!",
                                 andText: "You have to provide a landscape and a portrait image.")
      return
    }

    // Make sure at least one platform is selected.
    if enabledPlatforms.count > 0 {
      // Generate the necessary images.
      try launchImage.generateImagesForPlatforms(enabledPlatforms,
                                                 fromPortrait: portraitImage,
                                                 andLandscape: landscapeImage)
    } else {
      // No platforms to generate images for.
      beginSheetModalWithMessage("No Platform selected!",
                                 andText: "You have to select at least one platform.")
    }
  }

  ///  Tells the model to save the generated asset catalog to the HD.
  ///
  ///  - parameter name: Asset catalog name.
  ///  - parameter url: File URL to save the catalog to.
  ///  - throws: A LaunchImageError.
  override func saveAssetCatalogNamed(name: String, toURL url: NSURL) throws {
    try launchImage.saveAssetCatalogNamed(name, toURL: url)
  }
}
