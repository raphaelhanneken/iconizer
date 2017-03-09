//
// IconizerViewControllerProtocol.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//


import Cocoa

// Adds some required functionality/requirements to NSViewController.
protocol IconizerViewControllerProtocol {

  var view: NSView { get set }

  ///  Base method for generating the required images.
  ///  Needs to be overridden by subclasses!
  ///
  ///  - throws: An asset catalog specific error.
  func generateRequiredImages() throws

  ///  Base method for saving the currently selected asset catalog.
  ///  Needs to be overridden by subclasses!
  ///
  ///  - parameter name: Name of the generated asset catalog.
  ///  - parameter url: File path to the directory to save the asset to.
  ///  - throws: An asset catalog specific error.
  func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws

  /// Opens a selected image and inserts it into the currently
  /// active image well.
  ///
  /// - Parameter image: The selected image.
  /// - Throws: An error, in case the selected image couldn't be opened.
  func openSelectedImage(_ image: NSImage?) throws

}
