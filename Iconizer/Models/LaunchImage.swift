//
// LaunchImage.swift
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

///  Generates the necessary images for a launch image and saves itself to the HD.
class LaunchImage: NSObject {

  /// Holds the information from LaunchImage.json
  var images: [String : NSImage] = [:]

  /// Holds the image information for the contents.json
  var json: ContentsJSON!

  // swiftlint:disable cyclomatic_complexity

  ///  Generates the necessary images for the selected platforms.
  ///
  ///  - parameter platforms: Platforms to generate the images for.
  ///  - parameter portrait:  Portrait image provided by the user.
  ///  - parameter landscape: Landscape image provided by the user.
  ///  - throws: A LaunchImageError or ContentsJSONError.
  func generateImagesForPlatforms(_ platforms: [String], fromPortrait portrait: NSImage?,
                                  andLandscape landscape: NSImage?) throws {
    // Unwrap both images.
    guard let portrait = portrait, let landscape = landscape else {
      throw LaunchImageError.missingImage
    }
    // Get the JSON data for LaunchImage.
    json = try ContentsJSON(forType: AssetType.launchImage, andPlatforms: platforms)

    // Loop through the image data.
    for imgData in json.images {
      // Get the expected width.
      guard let width = imgData["expected-width"] else {
        throw LaunchImageError.missingDataForImageWidth
      }
      // Get the expected height.
      guard let height = imgData["expected-height"] else {
        throw LaunchImageError.missingDataForImageHeight
      }
      // Get the filename.
      guard let filename = imgData["filename"] else {
        throw LaunchImageError.missingDataForImageName
      }
      // Get the image orientation.
      guard let orientation = imgData["orientation"] else {
        throw LaunchImageError.missingDataForImageOrientation
      }
      // Get the idiom.
      guard let idiom = imgData["idiom"] else {
        throw LaunchImageError.missingDataForImageIdiom
      }

      // Is the current platform selected by the user?
      if platforms.contains(where: { $0.caseInsensitiveCompare(idiom) == .orderedSame }) {
        // Unwrap the width and height of the image
        guard let width = Int(width), let height = Int(height) else {
          throw LaunchImageError.formatError
        }

        // Check which image to create. And crop the original image to the required size.
        switch ImageOrientation(rawValue: orientation)! {
        case ImageOrientation.Portrait:
          images[filename] = portrait.imageByCroppingToSize(NSSize(width: width, height: height))

        case ImageOrientation.Landscape:
          images[filename] = landscape.imageByCroppingToSize(NSSize(width: width, height: height))
        }
      }
    }
  }

  ///  Saves the generated asset catalog to the HD:
  ///
  ///  - parameter name: Name of the asset catalog.
  ///  - parameter url:  URL to save the catalog to.
  ///  - throws: A NSImageExtentionError.
  func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
    // Create the correct file path.
    let url = url.appendingPathComponent("\(launchImageDir)/\(name).launchimage/",
      isDirectory: true)

    // Create the necessary folders.
    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)

    // Save the Contents.json
    try json.saveToURL(url)
    for (filename, img) in images {
      try img.saveAsPNGFileToURL(url.appendingPathComponent(filename))
    }

    // Reset the images array
    self.images = [:]
  }

}
