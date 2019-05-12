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
    /// Create an Icon for the iMessage.
    @IBOutlet weak var iMessage: NSButton!
    /// Holds the ImageView for the image to generate the App Icon from.
    @IBOutlet weak var imageView: NSImageView!

    /// Manage the user's preferences.
    let prefManager = PreferenceManager()

    /// Check which platforms are selected.
    var appPlatforms: [Platform] {
        // String array of selected platforms.
        var platform = [Platform]()
        if carPlay.state == .on {
            platform.append(Platform.car)
        }
        if iPad.state == .on {
            platform.append(Platform.iPad)
        }
        if iPhone.state == .on {
            platform.append(Platform.iPhone)
        }
        if osx.state == .on {
            platform.append(Platform.macOS)
        }
        if watch.state == .on {
            platform.append(Platform.watch)
        }
        if iPad.state == .on || iPhone.state == .on {
            platform.append(Platform.iOS)
        }
        if iMessage.state == .on {
            platform.append(Platform.iMessage)
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
        iMessage.state = .init(rawValue: prefManager.generateMessagesIcon)
    }

    override func viewWillDisappear() {
        prefManager.generateAppIconForAppleWatch = watch.state.rawValue
        prefManager.generateAppIconForIPad = iPad.state.rawValue
        prefManager.generateAppIconForIPhone = iPhone.state.rawValue
        prefManager.generateAppIconForMac = osx.state.rawValue
        prefManager.generateAppIconForCar = carPlay.state.rawValue
        prefManager.generateMessagesIcon = iMessage.state.rawValue
    }

    // MARK: Iconizer View Controller
    func saveAssetCatalog(named name: String, toURL url: URL) throws {
        guard let image = imageView.image else {
            throw IconizerViewControllerError.missingImage
        }

        guard appPlatforms.count > 0 else {
            throw IconizerViewControllerError.missingPlatform
        }

        let catalog = AssetCatalog<AppIcon>()

        try appPlatforms.forEach { platform in
            if platform == .iMessage {
                let iMessageCatalog = AssetCatalog<MessagesIcon>()
                try iMessageCatalog.add(.iMessage)
                try iMessageCatalog.save([.none: image], named: name, toURL: url)
            } else {
                try catalog.add(platform)
            }
        }

        try catalog.save([.none: image], named: name, toURL: url)
    }

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw IconizerViewControllerError.selectedImageNotFound
        }

        imageView.image = img
    }
}
