//
// LaunchImageViewController.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Handles the LaunchImage view.
class LaunchImageViewController: NSViewController, IconizerViewControllerProtocol {

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
        var tmp: [String] = []
        if iphone.state == NSOnState { tmp.append(kIPhonePlatformName) }
        if ipad.state   == NSOnState { tmp.append(kIPadPlatformName) }
        return tmp
    }

    /// Holds the LaunchImage model
    let launchImage = LaunchImage()

    /// Manages the user's preferences.
    let userPrefs = PreferenceManager()

    /// Name of the corresponding nib file.
    override var nibName: String {
        return "LaunchImageView"
    }

    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        self.iphone.state = userPrefs.generateLaunchImageForIPhone
        self.ipad.state   = userPrefs.generateLaunchImageForIPad
    }

    override func viewWillDisappear() {
        userPrefs.generateLaunchImageForIPad   = self.ipad.state
        userPrefs.generateLaunchImageForIPhone = self.iphone.state
    }

    // MARK: Iconizer View Controller

    func generateRequiredImages() throws {
        // Verify that both images are available.
        guard let landscapeImage = horizontal.image, let portraitImage = portrait.image else {
            throw IconizerViewControllerError.missingImage
        }

        guard enabledPlatforms.count > 0 else {
            throw IconizerViewControllerError.missingPlatform
        }
        // Generate the necessary images.
        try launchImage.generateImagesForPlatforms(enabledPlatforms,
                                                   fromPortrait: portraitImage,
                                                   andLandscape: landscapeImage)
    }

    func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
        try launchImage.saveAssetCatalogNamed(name, toURL: url)
    }

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw LaunchImageError.selectedImageNotFound
        }

        if img.height > img.width {
            portrait.image   = img
        } else if img.height < img.width {
            horizontal.image = img
        } else {
            horizontal.image = img
            portrait.image   = img
        }
    }
}
