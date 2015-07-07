//
// ImageSet.swift
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

///  ImageSet model. Generates necessary images and saves itself to the HD.
class ImageSet: NSObject {
    
     /// Holds the recalculated images.
    var images: [String : NSImage] = [:]
    
    ///  Creates images with the given resolutions from the given image.
    ///
    ///  :param: image       Base image.
    ///  :param: resolutions Resolutions to resize the given image to.
    ///
    ///  :returns: Returns true on success; False on failure.
    func generateScaledImagesFromImage(image: NSImage) -> Bool {
        // Use the original image as 3x
        self.images["3x"] = image
        
        // Calculate the 2x image
        self.images["2x"] = image.copyWithSize(NSSize(width: ceil(image.width / 1.5), height: ceil(image.height / 1.5)))
        
        // Calculate the 1x image
        self.images["1x"] = image.copyWithSize(NSSize(width: ceil(image.width / 3), height: ceil(image.height / 3)))
        
        // Check that the images are properly copied.
        if let image3x = self.images["3x"], let image2x = self.images["2x"], let image1x = self.images["1x"] {
            return true
        } else {
            return false
        }
    }
    
    ///  Saves the generated images to the HD.
    ///
    ///  :param: url File url to save the images to.
    func saveAssetCatalogToURL(url: NSURL) {
        // Manage the Contents.json
        let jsonFile = JSONFile()
        
        // Create the necessary folders.
        NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil, error: nil)
        
        // Loop through the generated images.
        for (resolution, image) in self.images {
            // Create a png representation of the current image.
            if let pngRep = image.PNGRepresentation() {
                // Create the filename.
                let filename = "image\(resolution).png"
                
                // Write the image data to the given url.
                if pngRep.writeToURL(url.URLByAppendingPathComponent(filename, isDirectory: false), atomically: true) {
                    jsonFile.buildImageSetDictForImageNamed(filename, scale: resolution)
                } else {
                    println("ERR: \(filename)")
                }
            }
        }
        
        // Tell the json object to write itself to the HD
        jsonFile.writeJSONFileToURL(url)
    }
}
