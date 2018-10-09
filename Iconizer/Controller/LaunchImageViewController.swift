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
    @IBOutlet weak var landscape: NSImageView!

    /// Holds the image view for the image to generate
    /// the portrait Launch Image from.
    @IBOutlet weak var portrait: NSImageView!

    /// Checkbox to create a Launch Image for iPhone.
    @IBOutlet weak var iphone: NSButton!

    /// Checkbox to create a Launch Image for iPad.
    @IBOutlet weak var ipad: NSButton!

    /// Select the fill mode for the launch image.
    @IBOutlet weak var aspectMode: NSPopUpButton!

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
        return "LaunchImageView"
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
        guard enabledPlatforms.count > 0 else {
            throw IconizerViewControllerError.missingPlatform
        }

        if let selectedAspectMode = aspectMode.selectedItem?.identifier?.rawValue {
            try launchImage.generateImagesForPlatforms(enabledPlatforms,
                                                       fromPortrait: self.portrait.image,
                                                       andLandscape: self.landscape.image,
                                                       mode: AspectMode(rawValue: selectedAspectMode))
        }
    }

    func saveAssetCatalog(named name: String, toURL url: URL) throws {
        try launchImage.saveAssetCatalogNamed(name, toURL: url)
    }

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw LaunchImageError.selectedImageNotFound
        }
        let ratio = img.height / img.width
        if 1 <= ratio {
            portrait.image  = img
        }
        if 1 >= ratio {
            landscape.image = img
        }
    }
}
