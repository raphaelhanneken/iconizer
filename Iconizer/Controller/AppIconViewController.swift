//
// AppIconViewController.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Controller for the AppIconView
class AppIconViewController: NSViewController, IconizerViewControllerProtocol {

    /// Create an App Icon for Apple Car Play.
    @IBOutlet weak var carPlay: NSButton!
    /// Create an App Icon for the iPad.
    @IBOutlet weak var iPad: NSButton!
    /// Create an App Icon for the iPhone.
    @IBOutlet weak var iPhone: NSButton!
    /// Crete an App Icon for macOS.
    @IBOutlet weak var osx: NSButton!
    /// Create an App Icon for the Apple Watch.
    @IBOutlet weak var watch: NSButton!
    /// Export the selected App Icons as comibined asset.
    @IBOutlet weak var combined: NSButton!
    /// Holds the ImageView for the image to generate the App Icon from.
    @IBOutlet weak var imageView: NSImageView!

    /// Responsible for creating and saving the asset catalog.
    let appIcon = AppIcon()

    /// Manage the user's preferences.
    let prefManager = PreferenceManager()

    /// Check which platforms are selected.
    var enabledPlatforms: [String] {
        // String array of selected platforms.
        var tmp: [String] = []
        if self.carPlay.state == NSOnState { tmp.append(carPlayPlatformName) }
        if self.iPad.state    == NSOnState { tmp.append(iPadPlatformName) }
        if self.iPhone.state  == NSOnState { tmp.append(iPhonePlatformName) }
        if self.osx.state     == NSOnState { tmp.append(macOSPlatformName) }
        if self.watch.state   == NSOnState { tmp.append(appleWatchPlatformName) }

        return tmp
    }

    /// The name of the corresponding nib file.
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

    // MARK: Iconizer View Controller

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

    func saveAssetCatalog(named name: String, toURL url: URL) throws {
        try appIcon.saveAssetCatalogNamed(name, toURL: url, asCombinedAsset: (combined.state == NSOnState))
    }

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw AppIconError.selectedImageNotFound
        }

        imageView.image = img
    }
}
