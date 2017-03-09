//
// AppIconViewController.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

///  Handles the AppIconView
class AppIconViewController: NSViewController, IconizerViewControllerProtocol {

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
        if self.iPad.state == NSOnState { tmp.append(kIPadPlatformName) }
        if self.iPhone.state == NSOnState { tmp.append(kIPhonePlatformName) }
        if self.osx.state == NSOnState { tmp.append(kOSXPlatformName) }
        if self.watch.state == NSOnState { tmp.append(kAppleWatchPlatformName) }

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
        watch.state = prefManager.generateAppIconForAppleWatch
        iPhone.state = prefManager.generateAppIconForIPhone
        iPad.state = prefManager.generateAppIconForIPad
        osx.state = prefManager.generateAppIconForMac
        carPlay.state = prefManager.generateAppIconForCar
        combined.state = prefManager.combinedAppIconAsset
    }

    override func viewWillDisappear() {
        // Save the checkbox states.
        prefManager.generateAppIconForAppleWatch = watch.state
        prefManager.generateAppIconForIPad = iPad.state
        prefManager.generateAppIconForIPhone = iPhone.state
        prefManager.generateAppIconForMac = osx.state
        prefManager.generateAppIconForCar = carPlay.state
        prefManager.combinedAppIconAsset = combined.state
    }

    // MARK: - Iconizer View Controller

    func generateRequiredImages() throws {
        guard let image = imageView.image else {
            throw IconizerViewControllerError.missingImage
        }

        guard enabledPlatforms.count > 0 else {
            throw IconizerViewControllerError.missingPlatform
        }

        // Generate the necessary images.
        try appIcon.generateImagesForPlatforms(enabledPlatforms, fromImage: image)
    }

    func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
        try appIcon.saveAssetCatalogNamed(name, toURL: url, asCombinedAsset: (combined.state == NSOnState))
    }

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw AppIconError.selectedImageNotFound
        }

        imageView.image = img
    }
}
