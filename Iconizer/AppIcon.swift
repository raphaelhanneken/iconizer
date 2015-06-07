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

/// Name of the directory, where Iconizer saves the asset catalogs.
let dirName = "Iconizer Assets"


class AppIcon: NSObject {
    
     /// Holds the resized images.
    var images: [String : Array<[String : NSImage?]>] = [:]
    
     /// Holds the required image sizes for each platform.
    var sizes: [String : [String : Int]] = [:]
    
     /// Manages building and saving of the contents.json
    let jsonFile = JSONFile()
    
    
    override init() {
        // required icon sizes for OS X
        self.sizes["Mac"] = ["appicon-16@1x": 16, "appicon-16@2x": 32, "appicon-32@1x": 32, "appicon-32@2x": 64, "appicon-128@1x": 128, "appicon-128@2x": 256, "appicon-256@1x": 256, "appicon-256@2x": 512, "appicon-512@1x": 512, "appicon-512@2x": 1024]
        
        // required icon sizes for iPhone
        self.sizes["iPhone"] = ["settings-@1x": 29, "ettings-@2x": 58, "settings-@3x": 87, "spotlight-@2x": 80, "spotlight-@3x": 120, "appicon-@2x": 120, "appicon-@3x": 180, "oldAppicon-@1x": 57, "oldAppicon-@2x": 114]
        
        // required icon sizes for Apple Watch
        self.sizes["Watch"] = ["notificationCenter-38mm@2x": 48, "notificationCenter-42mm@2x": 55, "companionSettings-@2x": 58, "companionSettings-@3x": 87, "appLauncher-38mm@2x": 80, "longLook-42mm@2x": 88, "quickLook-38mm@2x": 172, "quickLook-42mm@2x": 196]
        
        // required icon sizes for iPad
        self.sizes["iPad"] = ["settings-@1x": 29, "settings-@2x": 58, "spotlight-@1x": 40, "spotlight-@2x": 80, "oldSpotlight-@1x": 50, "oldSpotlight-@2x": 100, "appicon-@1x": 76, "appicon-@2x": 152, "oldAppicon-@1x": 72, "oldAppicon-@2x": 144]
        
        // required icon sizes for CarPlay
        self.sizes["Car"] = ["carplay-@1x": 120]
    }
    
    ///  Generate all necessary images for each selected platform.
    ///
    ///  :param: platforms Platforms to generate icons for.
    ///  :param: image     The image to Iconize.
    func generateImagesForPlatforms(platforms: [String], fromImage image: NSImage) {
        // Loop through the selected platforms
        for platform in platforms {
            // Temporary array to hold the generated images.
            var images: [[String : NSImage?]] = []
            
            // Get the image sizes for the current platform.
            if let imageSizesForCurrentPlatform = self.sizes[platform] {
                // Loop through the image sizes.
                for (name, size) in imageSizesForCurrentPlatform {
                    // Resize the given image.
                    let resizedImage = image.copyWithSize(NSSize(width: size, height: size))
                    // Append the resized image to the temporary image array.
                    images.append([name : resizedImage])
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
        // Loop through the platforms, we generated images for.
        for (platform, images) in self.images {
            // Holds the complete file url.
            let iconsetURL: NSURL
            
            // Check wether we'll generate a combined assert or not.
            if combined {
                // For a combined asset catalog save the .xcasset directory into "Iconizer Assets"...
                iconsetURL = url.URLByAppendingPathComponent("/\(dirName)/Images.xcasset/AppIcon.appiconset", isDirectory: true)
            } else {
                // ...otherwise create a folder for each platform.
                iconsetURL = url.URLByAppendingPathComponent("/\(dirName)/\(platform)/Images.xcasset/AppIcon.appiconset", isDirectory: true)
            }
            
            // Create the required folder structure.
            NSFileManager.defaultManager().createDirectoryAtURL(iconsetURL, withIntermediateDirectories: true, attributes: nil, error: nil)
            
            // Loop through the images of the current platform.
            for images in images {
                // Unwrap the image name and image file.
                for (name, image) in images {
                    // Set the filename
                    let filename = "\(platform.lowercaseString)_\(name).png"
                    // Append the filename to the url
                    let fileURL  = iconsetURL.URLByAppendingPathComponent(filename, isDirectory: false)
                    
                    // Unwrap the image
                    if let icon = image {
                        // Get the PNG representation of the current image...
                        let pngRep = icon.PNGRepresentation()!
                        
                        // ...and save it to the given url.
                        if pngRep.writeToURL(fileURL, atomically: true) {
                            println(filename)
                        } else {
                            println("ERR: \(filename)")
                        }
                        
                        // Save the image information to the JSON object.
                        self.jsonFile.buildDictForImageNamed(filename, forPlatform: platform, sized: icon.size)
                    }
                }
            }
        }
    }
}
