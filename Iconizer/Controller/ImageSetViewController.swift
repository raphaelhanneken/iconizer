//
// ImageSetViewController.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//


import Cocoa

/// Handles the ImageSet view.
class ImageSetViewController: NSViewController, IconizerViewControllerProtocol {

  /// Reference to the Image Well.
  @IBOutlet weak var imageView: NSImageView!

  /// Holds the ImageSet model
  let imageSet = ImageSet()

  /// Name of the corresponding nib file.
  override var nibName: String {
    return "ImageSetView"
  }

  // MARK: Mathods

  ///  Generate the necessary images.
  ///
  ///  - throws: An ImageSet Error.
  func generateRequiredImages() throws {
    guard let image = imageView.image else {
      throw IconizerViewControllerError.missingImage
    }

    imageSet.generateScaledImagesFromImage(image)
  }

  ///  Save the current asset catalog to the supplied url.
  ///
  ///  - parameter name: The name of the catalog to save.
  ///  - parameter url:  The destination path to save the assets to.
  ///  - throws: An ImageSetError.
  func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
    try imageSet.saveAssetCatalogNamed(name, toURL: url)
  }

  func openSelectedImage(_ image: NSImage?) throws {
    guard let img = image else {
      throw ImageSetError.selectedImageNotFound
    }

    imageView.image = img
  }

}
