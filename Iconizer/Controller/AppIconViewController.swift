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

    /// Manage the user's preferences.
    let prefManager = PreferenceManager()

    /// Check which platforms are selected.
    var enabledPlatforms: [Platform] {
        // String array of selected platforms.
        var platform = [Platform]()
        if carPlay.state == NSControl.StateValue.on {
            platform.append(Platform.car)
        }
        if iPad.state == NSControl.StateValue.on {
            platform.append(Platform.iPad)
        }
        if iPhone.state == NSControl.StateValue.on {
            platform.append(Platform.iPhone)
        }
        if osx.state == NSControl.StateValue.on {
            platform.append(Platform.macOS)
        }
        if watch.state == NSControl.StateValue.on {
            platform.append(Platform.watch)
        }
        if iPad.state == NSControl.StateValue.on || iPhone.state == NSControl.StateValue.on {
            platform.append(Platform.iOS)
        }
        return platform
    }

    /// The name of the corresponding nib file.
    override var nibName: NSNib.Name {
        return "AppIconView"
    }

    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()

        watch.state = .init(rawValue: prefManager.generateAppIconForAppleWatch)
        iPhone.state = .init(rawValue: prefManager.generateAppIconForIPhone)
        iPad.state = .init(rawValue: prefManager.generateAppIconForIPad)
        osx.state = .init(rawValue: prefManager.generateAppIconForMac)
        carPlay.state = .init(rawValue: prefManager.generateAppIconForCar)
    }

    override func viewWillDisappear() {
        prefManager.generateAppIconForAppleWatch = watch.state.rawValue
        prefManager.generateAppIconForIPad = iPad.state.rawValue
        prefManager.generateAppIconForIPhone = iPhone.state.rawValue
        prefManager.generateAppIconForMac = osx.state.rawValue
        prefManager.generateAppIconForCar = carPlay.state.rawValue
    }

    // MARK: Iconizer View Controller
    func saveAssetCatalog(named name: String, toURL url: URL) throws {
        guard let image = imageView.image else {
            throw IconizerViewControllerError.missingImage
        }

        guard enabledPlatforms.count > 0 else {
            throw IconizerViewControllerError.missingPlatform
        }

        let catalog = AssetCatalog<AppIcon>()

        try enabledPlatforms.forEach { platform in
            try catalog.addPlatform(platform)
        }

        try catalog.saveAssetCatalog(named: name, toURL: url, fromImage: [.none: image])
    }

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw IconizerViewControllerError.selectedImageNotFound
        }

        imageView.image = img
    }
}
