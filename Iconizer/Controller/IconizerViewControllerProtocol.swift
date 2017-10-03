//
// IconizerViewControllerProtocol.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

// Adds some required functionality/requirements to NSViewController.
protocol IconizerViewControllerProtocol {

    var view: NSView { get set }

    ///  Generate the images for the current asset type.
    ///
    ///  - Throws: An asset catalog specific error.
    func generateRequiredImages() throws

    /// Save the asset catalog.
    ///
    /// - Parameters:
    ///   - name: Name of the asset catalog to be generated.
    ///   - url: File path to the directory to save the asset catalog to.
    /// - Throws: An IconizerViewControllerError
    func saveAssetCatalog(named name: String, toURL url: URL) throws

    /// Open an image and insert it into the currently
    /// active image well.
    ///
    /// - Parameter image: The selected image.
    /// - Throws: An error, in case the selected image couldn't be opened.
    func openSelectedImage(_ image: NSImage?) throws
}
