//
//  IMessageIcon.swift
//  Iconizer
//
//  Created by Martin Kluska on 17.11.17.
//  Copyright © 2017 Raphael Hanneken. All rights reserved.
//

import Cocoa

/// Creates and saves an iMessage asset catalog.
class IMessageIcon: NSObject {
    
    /// The resized images.
    var images: [String: NSImage] = [:]
    
    /// Create all images for iMessage
    ///
    /// - Parameter image: The image to resize.
    func generateScaledImagesFromImage(_ image: NSImage) throws {
        // Create a new JSON object for the current platform.
        let jsonData = try ContentsJSON(forType: AssetType.appIcon, andPlatforms: ["iMessage"])
        // Calculate height from expected size (width)
        let aspectRatioScale: Float = 768/1024
        
        for imageData in jsonData.images {
            // Get the expected size, since App Icons are quadratic we only need one value.
            guard let width = imageData["expected-size"] else {
                throw IMessageError.missingDataForImageSize
            }
            // Get the filename.
            guard let filename = imageData["filename"] else {
                throw IMessageError.missingDataForImageName
            }
            
            if let width = Int(width) {
                let height = Int(aspectRatioScale * Float(width))
                // Append the generated image to the temporary images dict.
                images[filename] = image.resize(withSize: NSSize(width: width, height: height))
            } else {
                throw IMessageError.formatError
            }
        }
    }
    
    /// Write the iMessage icon to the supplied file url.
    ///
    /// - Parameters:
    ///   - name: The name of the asset catalog.
    ///   - url: The URL to save the catalog to.
    /// - Throws: See IMessageError for possible values.
    func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
        // Create the correct file path.
        let url = url.appendingPathComponent("\(iMessageDir)/\(name).stickersiconset", isDirectory: true)
        // Create the necessary folders.
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true,
                                                attributes: nil)
        
        // Manage the Contents.json with an empty platforms array since we don't care
        // about platforms for Image Sets.
        var jsonFile = try ContentsJSON(forType: AssetType.appIcon, andPlatforms: ["iMessage"])
        // Save the Contents.json to the HD.
        try jsonFile.saveToURL(url)
        
        // Loop through the image data.
        for image in jsonFile.images {
            // Unwrap the information we need.
            guard let filename = image["filename"] else {
                throw IMessageError.missingDataForImageName
            }
            // Get the correct image.
            guard let img = self.images[filename] else {
                throw IMessageError.missingImage
            }
            // Save the png representation to the supplied url.
            try img.savePngTo(url: url.appendingPathComponent(filename))
        }
        
        // Reset the images array
        images = [:]
    }
}
