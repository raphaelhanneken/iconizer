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

    /// Responsible for creating and saving the asset catalog.
    let imageSet = ImageSet()

    /// The name of the corresponding nib file.
    override var nibName: NSNib.Name {
        return "ImageSetView"
    }

    // MARK: Iconizer View Controller

    func generateRequiredImages() throws {
        guard let image = imageView.image else {
            throw IconizerViewControllerError.missingImage
        }
        try imageSet.generateScaledImagesFromImage(image)
    }

    func saveAssetCatalog(named name: String, toURL url: URL) throws {
        try imageSet.saveAssetCatalogNamed(name, toURL: url)
    }

    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw ImageSetError.selectedImageNotFound
        }
        imageView.image = img
    }
}
