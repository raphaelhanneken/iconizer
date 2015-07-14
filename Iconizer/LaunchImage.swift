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
    ///  :param: platforms Platforms to generate the images for.
    ///  :param: portrait  Portrait image that should be used.
    ///  :param: landscape Landscape image that should be used.
    ///
    ///  :returns: True on success, false otherwise.
    func generateImagesForPlatforms(platforms: [String], fromPortrait portrait: NSImage?, andLandscape landscape: NSImage?) -> Bool {
        // Unwrapt both images.
        if let portrait = portrait, let landscape = landscape {
            // Get the JSON data for LaunchImage.
            self.jsonData = ContentsJSON(forType: AssetType.LaunchImage, andPlatforms: platforms)
            
            // Loop through the image data.
            for imgData in jsonData.images {
                // Unwrap the required information.
                if let width = imgData["expected-width"]?.toInt(), let height = imgData["expected-height"]?.toInt(), let filename = imgData["filename"], let orientation = imgData["orientation"] {
                    // Check if the current platform was selected by the user
                    if let idiom = imgData["idiom"] {
                        if contains(platforms, {$0.caseInsensitiveCompare(idiom) == .OrderedSame}) {
                            // Check wether we have a portrait or landscape image
                            switch(orientation) {
                            case "portrait":
                                self.images[filename] = portrait.copyWithSize(NSSize(width: width, height: height))
                                
                            case "landscape":
                                self.images[filename] = landscape.copyWithSize(NSSize(width: width, height: height))
                                
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
    ///  :param: url File path to save the launch image to.
    func saveToURL(url: NSURL) {
        // Create the necessary folders.
        NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil, error: nil)
        
        for (filename, image) in self.images {
            if let png = image.PNGRepresentation() {
                if !png.writeToURL(url.URLByAppendingPathComponent(filename, isDirectory: false), atomically: true) {
                    print("ERR: \(filename)")
                }
            }
        }
        
        jsonData.saveToURL(url)
    }
}