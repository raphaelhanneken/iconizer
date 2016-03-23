//
// NSViewControllerExtensions.swift
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


// Adds some required functionality/requirements to NSViewController.
extension NSViewController {
  ///  Base method for generating the required images.
  ///  Needs to be overridden by subclasses!
  ///
  ///  - throws: An asset catalog specific error.
  func generateRequiredImages() throws { }

  ///  Base method for saving the currently selected asset catalog.
  ///  Needs to be overridden by subclasses!
  ///
  ///  - parameter name: Name of the generated asset catalog.
  ///  - parameter url: File path to the directory to save the asset to.
  ///  - throws: An asset catalog specific error.
  func saveAssetCatalogNamed(name: String, toURL url: NSURL) throws { }

  ///  Opens an NSAlert panel ontop of MainWindow.
  ///
  ///  - parameter message: messageText for the NSAlert.
  ///  - parameter text:    informativeText for the NSAlert.
  func beginSheetModalWithMessage(message: String, andText text: String) {
    // Create a new NSAlert message.
    let alert = NSAlert()
    // Configure the NSAlert.
    alert.messageText     = message
    alert.informativeText = text
    // Display!
    alert.beginSheetModalForWindow(self.view.window!, completionHandler: nil)
  }
}
