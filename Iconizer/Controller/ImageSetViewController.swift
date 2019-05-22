//
// ImageSetViewController.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Handles the ImageSet view.
class ImageSetViewController: NSViewController, IconizerViewControllerProtocol {

    /// Holds the image view for the image to generate
    /// the Image Set from.
    @IBOutlet weak var imageView: NSImageView!

    /// The name of the corresponding nib file.
    override var nibName: NSNib.Name {
        return "ImageSetView"
    }

    // MARK: Iconizer View Controller

    func saveAssetCatalog(named name: String, toURL url: URL) throws {
        guard let image = imageView.image else {
            throw IconizerViewControllerError.missingImage
        }

        let catalog = AssetCatalog<ImageSet>()
        try catalog.add(.undefined)
        try catalog.save([.all: image], named: name, toURL: url)
    }

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw IconizerViewControllerError.selectedImageNotFound
        }
        imageView.image = img
    }
}
