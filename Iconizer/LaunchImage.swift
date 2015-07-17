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
    var jsonData : ContentsJSON!
    
    
    ///  Generates the necessary images for the selected platforms.
    ///
    ///  - parameter platforms: Platforms to generate the images for.
    ///  - parameter portrait:  Portrait image that should be used.
    ///  - parameter landscape: Landscape image that should be used.
    ///
    ///  - returns: True on success, false otherwise.
    func generateImagesForPlatforms(platforms: [String], fromPortrait portrait: NSImage?, andLandscape landscape: NSImage?) -> Bool {
        // Unwrapt both images.
        if let portrait = portrait, let landscape = landscape {
            // Get the JSON data for LaunchImage.
            self.jsonData = ContentsJSON(forType: AssetType.LaunchImage, andPlatforms: platforms)
            
            // Loop through the image data.
            for imgData in jsonData.images {
                // Unwrap the required information.
                if let width = Int(imgData["expected-width"]!), let height = Int(imgData["expected-height"]!), let filename = imgData["filename"], let orientation = imgData["orientation"] {
                    // Check if the current platform was selected by the user
                    if let idiom = imgData["idiom"] {
                        if platforms.contains({$0.caseInsensitiveCompare(idiom) == .OrderedSame}) {
                            // Check wether we have a portrait or landscape image
                            switch(orientation) {
                            case "portrait":
                                self.images[filename] = portrait.cropToSize(NSSize(width: width, height: height))
                                
                            case "landscape":
                                self.images[filename] = landscape.cropToSize(NSSize(width: width, height: height))
                                
                            default:
                                continue
                            }
                        }
                    }
                }
            }
            
            return true
        }
        
        return false
    }
    
    ///  Saves the asset catalog to the HD.
    ///
    ///  - parameter url: File path to save the launch image to.
    func saveAssetCatalogToURL(url: NSURL) {
        // Create the correct file path.
        let url = url.URLByAppendingPathComponent("\(launchImageDirectory)/LaunchImage.launchimage/", isDirectory: true)
        
        do {
            // Create the necessary folders.
            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
        } catch _ {
        }
        
        for (filename, image) in self.images {
            if let png = image.PNGRepresentation() {
                if !png.writeToURL(url.URLByAppendingPathComponent(filename, isDirectory: false), atomically: true) {
                    print("Error writing file: \(filename)!")
                }
            } else {
                print("Getting PNG Representation for file \(filename) failed!")
            }
        }
        
        // Save the Contents.json
        jsonData.saveToURL(url)
        
        // Reset the images array
        self.images = [:]
    }
}