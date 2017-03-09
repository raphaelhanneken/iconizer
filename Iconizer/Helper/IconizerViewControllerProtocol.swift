//
// IconizerViewControllerProtocol.swift
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
