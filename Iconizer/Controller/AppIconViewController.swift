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
        if carPlay.state == NSControl.StateValue.on {
            tmp.append(Platform.car.rawValue)
        }
        if iPad.state == NSControl.StateValue.on {
            tmp.append(Platform.iPad.rawValue)
        }
        if iPhone.state == NSControl.StateValue.on {
            tmp.append(Platform.iPhone.rawValue)
        }
        if osx.state == NSControl.StateValue.on {
            tmp.append(Platform.macOS.rawValue)
        }
        if watch.state == NSControl.StateValue.on {
            tmp.append(Platform.watch.rawValue)
        }
        if iPad.state == NSControl.StateValue.on || iPhone.state == NSControl.StateValue.on {
            tmp.append(Platform.iOS.rawValue)
        }
        return tmp
    }

    /// The name of the corresponding nib file.
    override var nibName: NSNib.Name {
        return "AppIconView"
    }

    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        watch.state    = NSControl.StateValue(rawValue: prefManager.generateAppIconForAppleWatch)
        iPhone.state   = NSControl.StateValue(rawValue: prefManager.generateAppIconForIPhone)
        iPad.state     = NSControl.StateValue(rawValue: prefManager.generateAppIconForIPad)
        osx.state      = NSControl.StateValue(rawValue: prefManager.generateAppIconForMac)
        carPlay.state  = NSControl.StateValue(rawValue: prefManager.generateAppIconForCar)
    }

    override func viewWillDisappear() {
        prefManager.generateAppIconForAppleWatch = watch.state.rawValue
        prefManager.generateAppIconForIPad       = iPad.state.rawValue
        prefManager.generateAppIconForIPhone     = iPhone.state.rawValue
        prefManager.generateAppIconForMac        = osx.state.rawValue
        prefManager.generateAppIconForCar        = carPlay.state.rawValue
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
        try appIcon.saveCombinedAssetCatalog(named: name, toUrl: url)
    }

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw AppIconError.selectedImageNotFound
        }

        imageView.image = img
    }
}
