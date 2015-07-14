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
    var images: [String : Array<[String : NSImage?]>] = [:]
    
    ///  Generate all necessary images for each selected platform.
    ///
    ///  :param: platforms Platforms to generate icons for.
    ///  :param: image     The image to Iconize.
    func generateImagesForPlatforms(platforms: [String], fromImage image: NSImage) {
        // Loop through the selected platforms
        for platform in platforms {
            // Temporary array to hold the generated images.
            var images: [[String : NSImage?]] = []
            
            // Create a new JSON object for the current platform.
            let jsonData = ContentsJSON(forType: AssetType.AppIcon, andPlatforms: [platform])
            
            for imageData in jsonData.images {
                if let size = imageData["expected-size"]?.toInt(), let filename = imageData["filename"] {
                    images.append([filename : image.copyWithSize(NSSize(width: size, height: size))])
                }
            }
            
            // Write back the images to self.images
            self.images[platform] = images
        }
    }
    
    ///  Writes the generated images to the given file url.
    ///
    ///  :param: url      NSURL to save the asset catalog to.
    ///  :param: combined Save as combined catalog?
    func saveAssetCatalogToURL(url: NSURL, asCombinedAsset combined: Bool) {
        // Manage the Contents.json
        var jsonFile: ContentsJSON
        
        // Define where to save the asset catalog.
        var setURL = url.URLByAppendingPathComponent("/\(dirName)/AppIcon/Images.xcassets/AppIcon.appiconset", isDirectory: true)
        
        // Loop through the selected platforms.
        for (platform, images) in self.images {
            // Override the setURL in case we don't generate a combined asset.
            if !combined {
                setURL = url.URLByAppendingPathComponent("/\(dirName)/\(platform)/Images.xcassets/AppIcon.appiconset", isDirectory: true)
            }
            
            // Create the necessary folders.
            NSFileManager.defaultManager().createDirectoryAtURL(setURL, withIntermediateDirectories: true, attributes: nil, error: nil)
            
            // Loop through the images of the current platform.
            for image in images {
                // Get each image + filename.
                for (filename, image) in image {
                    // Append the filename to the appiconset url.
                    let fileURL = setURL.URLByAppendingPathComponent(filename, isDirectory: false)
                    
                    // Unwrap the image
                    if let icon = image?.PNGRepresentation() {
                        icon.writeToURL(fileURL, atomically: true)
                    }
                }
            }
            
            // Handle the Contents.json for each platform.
            if !combined {
                // Get the Contents.json for the current platform...
                jsonFile = ContentsJSON(forType: AssetType.AppIcon, andPlatforms: [platform])
                // ...and save it to the given file url.
                jsonFile.saveToURL(setURL)
            }
        }
        
        // Handle the Contents.json for all platforms at once.
        if combined {
            // Get the Contents.json for all selected platforms...
            jsonFile = ContentsJSON(forType: AssetType.AppIcon, andPlatforms: self.images.keys.array)
            // ...and save it to the given file url.
            jsonFile.saveToURL(setURL)
        }
    }
}
