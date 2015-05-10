//
//  IconizerModel.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 06/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

class ImageGenerator {
    
    var icnImages: [String : Array<[String : NSImage?]>]                  // Contains NSImage objects
    var icnSizes: [String : Dictionary<String, Int>]                      // Holds the required image sizes for each platform
    
    
    
    init() {
        icnImages = [:]
        icnSizes  = [:]
        
        // required icon sizes for mac
        icnSizes["Mac"] = ["AppIcon-16@1x": 16, "AppIcon-16@2x": 32, "AppIcon-32@1x": 32, "AppIcon-32@2x": 64, "AppIcon-128@1x": 128, "AppIcon-128@2x": 256, "AppIcon-256@1x": 256, "AppIcon-256@2x": 512, "AppIcon-512@1x": 512, "AppIcon-512@2x": 1024]
        
        // required icon sizes for iphone
        icnSizes["iPhone"] = ["settings-@2x": 58, "settings-@3x": 87, "spotlight-@2x": 80, "spotlight-@3x": 120, "AppIcon-@2x": 120, "AppIcon-@3x": 180]
        
        // required icon sizes for apple watch
        icnSizes["Watch"] = ["notificationCenter-38mm@2x": 48, "notificationCenter-42mm@2x": 55, "companionSettings-@2x": 58, "companionSettings-@3x": 87, "appLauncher-38mm@2x": 80, "longLook-42mm@2x": 88, "quickLook-38mm@2x": 172, "quickLook-42mm@2x": 196]
        
        // required icon sizes for ipad
        icnSizes["iPad"] = ["settings-@1x": 29, "settings-@2x": 58, "spotlight-@1x": 40, "spotlight-@2x": 80, "AppIcon-@1x": 76, "AppIcon-@2x": 152]
    }
    
    
    // Generates the necessary images, to create the image assets for the selected platforms
    func generateImagesFrom(image: NSImage?, forPlatforms platforms: [String]) {
        // Unwrap given image
        if let img = image {
            // Loop through selected platforms
            for platform in platforms {
                // Temporary array to hold the generated NSImage objects
                var images: [[String : NSImage?]] = []
                
                // Get the image sizes for the given platforms
                if let platformIconSizes = icnSizes[platform] {
                    // Loop through the image sizes
                    for (name, size) in platformIconSizes {
                        // Kick off actual resizing
                        let resizedImage = resizeImage(img, toSize: NSSize(width: size, height: size))
                        // Append the resized image to the temporary image array
                        images.append([name : resizedImage])
                    }
                }
                // Write back the images to the icnImages property
                icnImages[platform] = images
            }
        }
    }
    
    
    // Resizes a given NSImage to the given NSSize. And returns the resized
    // NSImage as optional
    func resizeImage(image: NSImage, toSize size: NSSize) -> NSImage? {
        // Create a new rect with given width and height
        let frame    = NSMakeRect(0, 0, size.width, size.height)
        // Extract an image representation for the frame rect
        let imageRep = image.bestRepresentationForRect(frame, context: nil, hints: nil)
        // Create an empty NSImage with the given size
        let newImage = NSImage(size: size)
        
        // Draw the newly sized image
        newImage.lockFocus()
        imageRep?.drawInRect(frame)
        newImage.unlockFocus()
        
        // Return the resized image
        return newImage
    }
}