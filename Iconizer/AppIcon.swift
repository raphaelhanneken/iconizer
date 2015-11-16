//
// AppIcon.swift
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


/// Generates the necessary images for an AppIcon and saves them onto the HD.
class AppIcon: NSObject {
    
    /// Holds the resized images.
    var images: [String : [String : NSImage?]] = [:]
    
    ///  Generate all necessary images for each selected platform.
    ///
    ///  - parameter platforms: Platforms to generate icons for.
    ///  - parameter image:     The image to Iconize.
    func generateImagesForPlatforms(platforms: [String], fromImage image: NSImage) throws {
        // Loop through the selected platforms
        for platform in platforms {
            // Temporary dict to hold the generated images.
            var tmpImages: [String : NSImage?] = [:]
            
            // Create a new JSON object for the current platform.
            let jsonData = ContentsJSON(forType: AssetType.AppIcon, andPlatforms: [platform])
            
            for imageData in jsonData.images {
                // Get the expected size, since App Icons are quadratic we only need one value.
                guard let size = imageData["expected-size"] else {
                    throw AppIconError.MissingDataForImageSize
                }
                // Get the filename.
                guard let filename = imageData["filename"] else {
                    throw AppIconError.MissingDataForImageName
                }

                if let size = Int(size) {
                    // Append the generated image to the temporary images dict.
                    tmpImages[filename] = image.copyWithSize(NSSize(width: size, height: size))
                } else {
                    throw AppIconError.FormatError
                }
            }
            
            // Write back the images to self.images
            self.images[platform] = tmpImages
        }
    }
    
    ///  Writes the generated images to the given file url.
    ///
    ///  - parameter url:      NSURL to save the asset catalog to.
    ///  - parameter combined: Save as combined catalog?
    func saveAssetCatalogNamed(name: String, toURL url: NSURL, asCombinedAsset combined: Bool) throws {
        // Define where to save the asset catalog.
        var setURL = url.URLByAppendingPathComponent("\(appIconDirectory)/Combined/\(name).appiconset", isDirectory: true)
        
        // Loop through the selected platforms.
        for (platform, images) in self.images {
            // Override the setURL in case we don't generate a combined asset.
            if !combined {
                setURL = url.URLByAppendingPathComponent("\(appIconDirectory)/\(platform)/\(name).appiconset", isDirectory: true)
                
                // Create the necessary folders.
                try NSFileManager.defaultManager().createDirectoryAtURL(setURL, withIntermediateDirectories: true, attributes: nil)
                
                // Get the Contents.json for the current platform...
                var jsonFile = ContentsJSON(forType: AssetType.AppIcon, andPlatforms: [platform])
                // ...and save it to the given file url.
                try jsonFile.saveToURL(setURL)
            } else {
                // Create the necessary folders for a combined asset catalog.
                try NSFileManager.defaultManager().createDirectoryAtURL(setURL, withIntermediateDirectories: true, attributes: nil)
                // Get the Contents.json for all selected platforms...
                var jsonFile = ContentsJSON(forType: AssetType.AppIcon, andPlatforms: Array(self.images.keys))
                // ...and save it to the given file url.
                try jsonFile.saveToURL(setURL)
            }

            // Get each image object + filename.
            for (filename, image) in images {
                // Append the filename to the appiconset url.
                let fileURL = setURL.URLByAppendingPathComponent(filename, isDirectory: false)
                
                // Unwrap the image object.
                guard let img = image else {
                    throw AppIconError.MissingImage
                }
                
                do {
                    try img.savePNGRepresentationToURL(fileURL)
                } catch {
                    print(error)
                }
            }
        }
        
        // Reset the images array
        self.images = [:]
    }
}
