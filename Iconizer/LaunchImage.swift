//
// LaunchImage.swift
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


///  LaunchImage model. Generates necessary images and saves itself to the HD.
class LaunchImage: NSObject {
    
    /// Holds the information from LaunchImage.json
    var images: Dictionary<String, NSImage> = [:]
    
    /// Holds the image information for the contents.json
    var json : ContentsJSON!
    
    
    ///  Generates the necessary images for the selected platforms.
    ///
    ///  - parameter platforms: Platforms to generate the images for.
    ///  - parameter portrait:  Portrait image that should be used.
    ///  - parameter landscape: Landscape image that should be used.
    ///
    ///  - returns: True on success, false otherwise.
    func generateImagesForPlatforms(platforms: [String], fromPortrait portrait: NSImage?, andLandscape landscape: NSImage?) throws {
        // Unwrap both images.
        guard let portrait = portrait, let landscape = landscape else {
            throw LaunchImageError.MissingImage
        }
        
        // Get the JSON data for LaunchImage.
        json = ContentsJSON(forType: AssetType.LaunchImage, andPlatforms: platforms)
        
        // Loop through the image data.
        for imgData in json.images {
            // Get the expected width.
            guard let width = imgData["expected-width"] else {
                throw LaunchImageError.MissingDataForImageWidth
            }
            
            // Get the expected height.
            guard let height = imgData["expected-height"] else {
                throw LaunchImageError.MissingDataForImageHeight
            }
            
            // Get the filename.
            guard let filename = imgData["filename"] else {
                throw LaunchImageError.MissingDataForImageName
            }
            
            // Get the image orientation.
            guard let orientation = imgData["orientation"] else {
                throw LaunchImageError.MissingDataForImageOrientation
            }
            
            // Get the idiom.
            guard let idiom = imgData["idiom"] else {
                throw LaunchImageError.MissingDataForImageIdiom
            }
            
            // Is the current platform selected by the user?
            if platforms.contains({ $0.caseInsensitiveCompare(idiom) == .OrderedSame }) {
                // Check which image to create. And crop the original image to the required size.
                switch(ImageOrientation(rawValue: orientation)!) {
                    case ImageOrientation.Portrait:
                        images[filename] = portrait.cropToSize(NSSize(width: Int(width)!, height: Int(height)!))
                    
                    case ImageOrientation.Landscape:
                        images[filename] = landscape.cropToSize(NSSize(width: Int(width)!, height: Int(height)!))
                }
            }
        }
    }
    
    ///  Saves the asset catalog to the HD.
    ///
    ///  - parameter url: File path to save the launch image to.
    func saveAssetCatalogToURL(url: NSURL) throws {
        // Create the correct file path.
        let url = url.URLByAppendingPathComponent("\(launchImageDirectory)/LaunchImage.launchimage/", isDirectory: true)
        
        // Create the necessary folders.
        try! NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
        
        // Save the Contents.json
        try! json.saveToURL(url)
        
        for (filename, img) in images {
            // Create a PNG representation and write it to the HD.
            if let png = img.PNGRepresentation() {
                do {
                    try png.writeToURL(url.URLByAppendingPathComponent(filename), options: .DataWritingAtomic)
                } catch {
                    print(error)
                }
            }
        }
        
        // Reset the images array
        self.images = [:]
    }
}