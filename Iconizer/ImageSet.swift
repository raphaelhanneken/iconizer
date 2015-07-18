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


/// Generates the necessary images for an ImageSet and saves them to the HD.
class ImageSet: NSObject {
    
    /// Holds the recalculated images.
    var images: [String : NSImage] = [:]
    
    
    ///  Creates images with the given resolutions from the given image.
    ///
    ///  - parameter image:       Base image.
    ///  - parameter resolutions: Resolutions to resize the given image to.
    ///
    ///  - returns: Returns true on success; False on failure.
    func generateScaledImagesFromImage(image: NSImage) throws {
        // Define the new image sizes.
        let x1 = NSSize(width: ceil(image.width / 3), height: ceil(image.height / 3))
        let x2 = NSSize(width: ceil(image.width / 1.5), height: ceil(image.height / 1.5))
        
        // Calculate the 2x and 1x images.
        images["1x"] = image.copyWithSize(x1)
        images["2x"] = image.copyWithSize(x2)
        
        // Assign the original images as the 3x image.
        images["3x"] = image
    }
    
    ///  Saves the generated images to the HD.
    ///
    ///  - parameter url: File url to save the images to.
    func saveAssetCatalogToURL(url: NSURL, withName name: String) throws {
        // Create the correct file path.
        let url = url.URLByAppendingPathComponent("\(imageSetDirectory)/\(name).imageset", isDirectory: true)
        
        // Create the necessary folders.
        try! NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
        
        // Manage the Contents.json with an empty platforms array since we don't care
        // about platforms for Image Sets.
        var jsonFile = ContentsJSON(forType: AssetType.ImageSet, andPlatforms: [""])
        
        // Loop through the image data.
        for image in jsonFile.images {
            // Unwrap the information we need.
            guard let scale = image["scale"], let filename = image["filename"] else {
                throw ImageSetError.GettingJSONDataFailed
            }
            
            // Get the correct image.
            guard let img = self.images[scale] else {
                throw ImageSetError.ImageNotFound
            }
            
            // Create a PNG representation and write it to the HD.
            if let png = img.PNGRepresentation() {
                try! png.writeToURL(url.URLByAppendingPathComponent(filename), options: .DataWritingAtomic)
            }
        }
        
        // Save the Contents.json to the HD.
        try! jsonFile.saveToURL(url)
        
        // Reset the images array
        self.images = [:]
    }
}
