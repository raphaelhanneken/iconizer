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

class ImageSetViewController: ExportTypeController {
    
     /// Reference to the Image Well.
    @IBOutlet weak var imageView: NSImageView!
     /// Checkbox: Export @3x version.
    @IBOutlet weak var export3x: NSButton!
     /// Checkbox: Export @2x version.
    @IBOutlet weak var export2x: NSButton!
     /// Checkbox: Export @1x version.
    @IBOutlet weak var export1x: NSButton!
     /// Name of the generated image asset.
    @IBOutlet weak var imageName: NSTextField!
    
     /// Holds the ImageSet model
    let imageSet = ImageSet()
    
    override var nibName: String {
        return "ImageSetView"
    }
    
    ///  Holds all selected image resolution.
    var selectedImageSizes: [String] {
        get {
            // Build an array filled with selected image resolution.
            var tmp: [String] = []
            if export3x.state == NSOnState { tmp.append("3x") }
            if export2x.state == NSOnState { tmp.append("2x") }
            if export1x.state == NSOnState { tmp.append("1x") }
            
            return tmp
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func generateRequiredImages() -> Bool {
        // Unwrap the image object from the view.
        if let image = self.imageView.image {
            // Check if at least one image resolution is selected.
            if self.selectedImageSizes.count > 0 {
                if self.imageName.stringValue.isEmpty {
                    // The user hasn't provided any image name!
                    self.beginSheetModalWithMessage("No image name!", andText: "You forgot to specify an image name.")
                } else {
                    // Everything alright here!
                    // Tell the model to generate the required images
                    if imageSet.generateImagesFromImage(image, withResolutions: self.selectedImageSizes) {
                        return true
                    }
                }
            } else {
                // No selected resolutions...
                self.beginSheetModalWithMessage("No Resolution!", andText: "You haven't selected any image resolutions.")
            }
        } else {
            // We forgot the image here.
            self.beginSheetModalWithMessage("No Image!", andText: "You haven't dropped any image to convert.")
        }
        
        return false
    }
    
    override func saveToURL(url: NSURL) {
        self.imageSet.saveAssetCatalogToURL(url.URLByAppendingPathComponent("\(dirName)/Images.xcasset/\(self.imageName.stringValue).imageset/", isDirectory: true))
    }
}
