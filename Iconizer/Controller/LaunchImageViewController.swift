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
    var enabledPlatforms: [Platform] {
        var platforms = [Platform]()
        if iphone.state == NSControl.StateValue.on {
            platforms.append(Platform.iPhone)
        }
        if ipad.state == NSControl.StateValue.on {
            platforms.append(Platform.iPad)
        }
        return platforms
    }

    /// Manage the user's preferences.
    let prefManager = PreferenceManager()

    /// The name of the corresponding nib file.
    override var nibName: NSNib.Name {
        return "LaunchImageView"
    }

    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        iphone.state = .init(rawValue: prefManager.generateLaunchImageForIPhone)
        ipad.state = .init(rawValue: prefManager.generateLaunchImageForIPad)
    }

    override func viewWillDisappear() {
        prefManager.generateLaunchImageForIPad = ipad.state.rawValue
        prefManager.generateLaunchImageForIPhone = iphone.state.rawValue
    }

    // MARK: Iconizer View Controller

    // swiftlint:disable cyclomatic_complexity
    func saveAssetCatalog(named name: String, toURL url: URL) throws {
        guard enabledPlatforms.count > 0 else {
            throw IconizerViewControllerError.missingPlatform
        }

        guard let selectedAspectMode = aspectMode.selectedItem?.identifier?.rawValue,
              let mode = AspectMode(rawValue: selectedAspectMode) else {
            throw IconizerViewControllerError.missingAspectMode
        }

        var images = [ImageOrientation: NSImage]()
        if let portrait = self.portrait.image {
            images[.portrait] = portrait
        }
        if let landscape = self.landscape.image {
            images[.landscape] = landscape
        }

        guard images.count > 0 else {
            throw IconizerViewControllerError.missingImage
        }

        let catalog = AssetCatalog<LaunchImage>()

        try enabledPlatforms.forEach { platform in
            if images[.landscape] != nil {
                try catalog.addPlatform(platform, orientation: .landscape)
            }

            if images[.portrait] != nil {
                try catalog.addPlatform(platform, orientation: .portrait)
            }
        }

        try catalog.save(images, named: name, toURL: url, aspect: mode)
    }
    // swiftlint:enable cyclomatic_complexity

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw IconizerViewControllerError.selectedImageNotFound
        }
        let ratio = img.height / img.width
        if 1 <= ratio {
            portrait.image = img
        }
        if 1 >= ratio {
            landscape.image = img
        }
    }
}
