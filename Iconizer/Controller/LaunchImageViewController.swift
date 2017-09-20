//
// LaunchImageViewController.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Controller for the LaunchImageView.
class LaunchImageViewController: NSViewController, IconizerViewControllerProtocol {

    /// Holds the image view for the image to generate
    /// the horizontal Launch Image from.
    @IBOutlet weak var horizontal: NSImageView!

    /// Holds the image view for the image to generate
    /// the portrait Launch Image from.
    @IBOutlet weak var portrait: NSImageView!

    /// Checkbox to create a Launch Image for iPhone.
    @IBOutlet weak var iphone: NSButton!

    /// Checkbox to create a Launch Image for iPad.
    @IBOutlet weak var ipad: NSButton!

    /// Return the platforms selected by the user.
    var enabledPlatforms: [String] {
        var tmp: [String] = []
        if iphone.state == NSControl.StateValue.on { tmp.append(iPhonePlatformName) }
        if ipad.state == NSControl.StateValue.on { tmp.append(iPadPlatformName) }
        return tmp
    }

    /// Responsible for creating and saving the asset catalog.
    let launchImage = LaunchImage()

    /// Manage the user's preferences.
    let userPrefs = PreferenceManager()

    /// The name of the corresponding nib file.
    override var nibName: NSNib.Name {
        return NSNib.Name("LaunchImageView")
    }

    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        iphone.state = NSControl.StateValue(rawValue: userPrefs.generateLaunchImageForIPhone)
        ipad.state = NSControl.StateValue(rawValue: userPrefs.generateLaunchImageForIPad)
    }

    override func viewWillDisappear() {
        userPrefs.generateLaunchImageForIPad = ipad.state.rawValue
        userPrefs.generateLaunchImageForIPhone = iphone.state.rawValue
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

    func saveAssetCatalog(named name: String, toURL url: URL) throws {
        try launchImage.saveAssetCatalogNamed(name, toURL: url)
    }

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw LaunchImageError.selectedImageNotFound
        }

        if img.height > img.width {
            portrait.image = img
        } else if img.height < img.width {
            horizontal.image = img
        } else {
            horizontal.image = img
            portrait.image = img
        }
    }
}
