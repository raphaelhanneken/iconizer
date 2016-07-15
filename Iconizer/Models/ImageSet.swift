//
// ImageSet.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
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


/// Generates the necessary images for an image set and saves them to the HD.
class ImageSet: NSObject {

  /// Holds the recalculated images.
  var images: [String : NSImage] = [:]

  ///  Creates a @1x and @2x image for the supplied image.
  ///
  ///  - parameter image: The image to copy and resize.
  func generateScaledImagesFromImage(_ image: NSImage) {
    // Define the new image sizes.
    let x1 = NSSize(width: ceil(image.width / 3), height: ceil(image.height / 3))
    let x2 = NSSize(width: ceil(image.width / 1.5), height: ceil(image.height / 1.5))

    // Calculate the 2x and 1x images.
    images["1x"] = image.imageByCopyingWithSize(x1)
    images["2x"] = image.imageByCopyingWithSize(x2)

    // Assign the original images as the 3x image.
    images["3x"] = image
  }

  ///  Saves the generated images to the HD.
  ///  - parameter name: The asset catalog name.
  ///  - parameter url:  The url where to save the catalog to.
  ///  - throws: A ContentsJSONError or ImageSetError.
  func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
    // Create the correct file path.
    let url = try! url.appendingPathComponent("\(imageSetDir)/\(name).imageset", isDirectory: true)
    // Create the necessary folders.
    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true,
                                                            attributes: nil)

    // Manage the Contents.json with an empty platforms array since we don't care
    // about platforms for Image Sets.
    var jsonFile = try ContentsJSON(forType: AssetType.imageSet, andPlatforms: [""])
    // Save the Contents.json to the HD.
    try jsonFile.saveToURL(url)

    // Loop through the image data.
    for image in jsonFile.images {
      // Unwrap the information we need.
      guard let scale = image["scale"], filename = image["filename"] else {
        throw ImageSetError.gettingJSONDataFailed
      }
      // Get the correct image.
      guard let img = self.images[scale] else {
        throw ImageSetError.missingImage
      }
      // Save the png representation to the supplied url.
      try img.saveAsPNGFileToURL(try! url.appendingPathComponent(filename))
    }

    // Reset the images array
    self.images = [:]
  }
}
