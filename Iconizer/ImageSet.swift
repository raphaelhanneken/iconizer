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
    func generateImagesFromImage(image: NSImage, withResolutions resolutions: [String]) -> Bool {
        // Loop through the resolutions. The old fashioned way...
        for var i = 0; i < resolutions.count; i++ {
            // ...since the highest resolution is always the first,
            // we can just save the original image as the highest selected resolution.
            if i == 0 {
                images[resolutions[i]] = image
                continue;
            }
            
            // Calculate the resolutions for 2x and 1x
            if resolutions[i] == "2x" {
                // Calculate the 2x image from the 3x image
                if let image = images["3x"] {
                    images["2x"] = image.copyWithSize(NSSize(width: ceil(image.width / 1.5), height: ceil(image.height / 1.5)))
                }
            }
            else if resolutions[i] == "1x" {
                // Calculate the 1x from the 2x image.
                if let image = images["2x"] {
                    images["1x"] = image.copyWithSize(NSSize(width: image.width / 2, height: image.height / 2))
                } else {
                    // In case we don't have a 2x image.
                    if let image = images["3x"] {
                        // Calculate the 1x from the 3x image.
                        images["1x"] = image.copyWithWidth(image.width / 4, height: image.height / 4)
                    }
                }
            }
        }
        
        // Dewy-eyed, as we are, we simply return true no matter what. Anyway: What could possibly go wrong...
        return true
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
