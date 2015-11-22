//
// ImageSetViewController.swift
// Iconizer
// https://github.com/behoernchen/Iconizer
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Raphael Hanneken
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

  ///  Tells the model to generate the necessary images.
  ///
  ///  - returns: True on success, false otherwise.
  override func generateRequiredImages() throws {
    // Unwrap the image object from the view.
    guard let image = imageView.image else {
      // We forgot the image here.
      beginSheetModalWithMessage("No Image!", andText: "You haven't dropped any image to convert.")
      return
    }

    // Tell the model to generate the required images.
    try imageSet.generateScaledImagesFromImage(image)
  }

  ///  Tells the model to save itself to the given file url.
  ///
  ///  - parameter name: App Icon name.
  ///  - parameter url: File url to save the ImageSet to.
  override func saveAssetCatalogNamed(name: String, toURL url: NSURL) throws {
    try imageSet.saveAssetCatalogNamed(name, toURL: url)
  }
}
