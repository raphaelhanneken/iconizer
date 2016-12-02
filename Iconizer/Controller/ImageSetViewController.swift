//
// ImageSetViewController.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Raphael Hanneken
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Cocoa

/// Handles the ImageSet view.
class ImageSetViewController: NSViewController {

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
  override func generateRequiredImages() throws {
    if let image = imageView.image {
      // Generate the required images.
      imageSet.generateScaledImagesFromImage(image)
    } else {
      // Whoops no images supplied.
      beginSheetModalWithMessage("No Image!", andText: "You haven't dropped any image to convert.")
    }
  }

  ///  Save the current asset catalog to the supplied url.
  ///
  ///  - parameter name: The name of the catalog to save.
  ///  - parameter url:  The destination path to save the assets to.
  ///  - throws: An ImageSetError.
  override func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
    try imageSet.saveAssetCatalogNamed(name, toURL: url)
  }
  
}
