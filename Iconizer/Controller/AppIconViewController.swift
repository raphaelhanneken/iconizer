//
// AppIconViewController.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Raphael Hanneken
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

///  Handles the AppIconView
class AppIconViewController: NSViewController {

  /// Export for Car Play?
  @IBOutlet weak var carPlay: NSButton!
  /// Export for iPad?
  @IBOutlet weak var iPad: NSButton!
  /// Export for iPhone?
  @IBOutlet weak var iPhone: NSButton!
  /// Export for OS X?
  @IBOutlet weak var osx: NSButton!
  /// Export for Apple Watch?
  @IBOutlet weak var watch: NSButton!
  /// Export as combined asset?
  @IBOutlet weak var combined: NSButton!
  /// Image Well.
  @IBOutlet weak var imageView: NSImageView!

  /// Holds the AppIcon model
  let appIcon = AppIcon()

  /// Manages the user's preferences.
  let prefManager = PreferenceManager()

  /// Which platforms are actually selected?
  var enabledPlatforms: [String] {
    // String array of selected platforms.
    var tmp: [String] = []
    if self.carPlay.state == NSOnState { tmp.append(kCarPlayPlatformName) }
    if self.iPad.state    == NSOnState { tmp.append(kIPadPlatformName) }
    if self.iPhone.state  == NSOnState { tmp.append(kIPhonePlatformName) }
    if self.osx.state     == NSOnState { tmp.append(kOSXPlatformName ) }
    if self.watch.state   == NSOnState { tmp.append(kAppleWatchPlatformName) }

    return tmp
  }

  /// Name of the corresponding nib file.
  override var nibName: String {
    return "AppIconView"
  }

  // MARK: View Controller

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set the checkbox states.
    watch.state    = prefManager.generateAppIconForAppleWatch
    iPhone.state   = prefManager.generateAppIconForIPhone
    iPad.state     = prefManager.generateAppIconForIPad
    osx.state      = prefManager.generateAppIconForMac
    carPlay.state  = prefManager.generateAppIconForCar
    combined.state = prefManager.combinedAppIconAsset
  }

  override func viewWillDisappear() {
    // Save the checkbox states.
    prefManager.generateAppIconForAppleWatch = watch.state
    prefManager.generateAppIconForIPad       = iPad.state
    prefManager.generateAppIconForIPhone     = iPhone.state
    prefManager.generateAppIconForMac        = osx.state
    prefManager.generateAppIconForCar        = carPlay.state
    prefManager.combinedAppIconAsset         = combined.state
  }

  // MARK: - Methods

  ///  Generate the required images.
  ///
  ///  - throws: An AppIcon error.
  override func generateRequiredImages() throws {
    // Unwrap the image from imageView
    guard let image = imageView.image else {
      // Oh snap! Forgot the image.
      beginSheetModalWithMessage("No Image!", andText: "You haven't dropped any image to convert.")
      return
    }

    // Check if at least one platform is selected.
    if enabledPlatforms.count > 0 {
      // Tell the model to generate it's images
      try appIcon.generateImagesForPlatforms(enabledPlatforms, fromImage: image)
    } else {
      // Whoops! We have no platforms.
      beginSheetModalWithMessage("No Platform!", andText: "You haven't selected any platforms yet.")
    }
  }

  ///  Save the current asset catalog to the given url.
  ///
  ///  - parameter name: The name of the app icon.
  ///  - parameter url:  URL to save the app icon to.
  ///  - throws: An AppIcon Error.
  override func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
    try appIcon.saveAssetCatalogNamed(name, toURL: url, asCombinedAsset: (combined.state == NSOnState))
  }

  override func openSelectedImage(_ image: NSImage?) throws {
    guard let img = image else {
      throw AppIconError.selectedImageNotFound
    }
    imageView.image = img
  }

}
