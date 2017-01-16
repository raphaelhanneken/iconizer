//
// NSImageExtensions.swift
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

extension NSImage {

  /// Returns the height of the current image.
  var height: CGFloat {
    return self.size.height
  }

  /// Returns the width of the current image.
  var width: CGFloat {
    return self.size.width
  }

  /// Returns a png representation of the current image.
  var PNGRepresentation: Data? {
    if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
      // Expected size (to
      let expectedSize = self.size

      // Resize bitmap image representation to expected size (since current size may be 2x if Retina)
      tiffData.size = expectedSize

      return tiffData.representation(using: .PNG, properties: [:])
    }

    return nil
  }

  // MARK: Resizing

  ///  Returns a new image that represents the original image after
  ///  resizing is to the supplied size.
  ///
  ///  - parameter size: The size of the new image.
  ///
  ///  - returns: The resized copy of the original image.
  func imageByCopyingWithSize(_ size: NSSize) -> NSImage? {
    // Create a new rect with given width and height
    let frame = NSRect(x: 0, y: 0, width: size.width, height: size.height)

    // Get the best representation for the given size.
    guard let rep = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
      return nil
    }

    // Create an empty image with the given size.
    let img = NSImage(size: size, flipped: false, drawingHandler: { (_) -> Bool in

      if rep.draw(in: frame) {
        return true
      }

      return false
    })

    return img

  }

  ///  Copies the current image and resizes it to the size of the given NSSize, while
  ///  maintaining the aspect ratio of the original image.
  ///
  ///  - parameter size: The size of the new image.
  ///
  ///  - returns: The resized copy of the given image.
  func resizeWhileMaintainingAspectRatioToSize(_ size: NSSize) -> NSImage? {
    let newSize: NSSize

    let widthRatio  = size.width / self.width
    let heightRatio = size.height / self.height

    if widthRatio > heightRatio {
      newSize = NSSize(width: floor(self.width * widthRatio),
                       height: floor(self.height * widthRatio))
    } else {
      newSize = NSSize(width: floor(self.width * heightRatio),
                       height: floor(self.height * heightRatio))
    }

    return self.imageByCopyingWithSize(newSize)
  }

  // MARK: Cropping

  ///  Resizes the original image, to nearly fit the supplied cropping size
  ///  and returns the cropped copy of the image.
  ///
  ///  - parameter size: The size of the new image.
  ///
  ///  - returns: The cropped copy of the given image.
  func imageByCroppingToSize(_ size: NSSize) -> NSImage? {
    // Resize the current image, while preserving the aspect ratio.
    guard let resized = self.resizeWhileMaintainingAspectRatioToSize(size) else {
      return nil
    }

    // Get some points to center the cropping area.
    let x = floor((resized.width - size.width) / 2)
    let y = floor((resized.height - size.height) / 2)
    // Create the cropping frame.
    let frame = NSMakeRect(x, y, size.width, size.height)

    // Get the best representation of the image for the given cropping frame.
    guard let rep = resized.bestRepresentation(for: frame, context: nil, hints: nil) else {
      return nil
    }

    // Create a new image with the new size
    let img = NSImage(size: size)
    defer { img.unlockFocus() }
    img.lockFocus()

    if rep.draw(in: NSMakeRect(0, 0, size.width, size.height),
                from: frame,
                operation: NSCompositingOperation.copy,
                fraction: 1.0,
                respectFlipped: false,
                hints: [:]) {
      return img  // Return the cropped image.
    }

    // Return nil in case anything fails.
    return nil
  }

  // MARK: Saving

  ///  Saves the PNG representation of the current image to the HD.
  ///
  ///  - parameter url: URL to save the png file to.
  ///  - throws: A NSImageExtensionError.
  func saveAsPNGFileToURL(_ url: URL) throws {
    if let png = self.PNGRepresentation {
      try png.write(to: url, options: .atomicWrite)
    } else {
      throw NSImageExtensionError.unwrappingPNGRepresentationFailed
    }
  }

}
