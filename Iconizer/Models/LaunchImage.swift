//
// LaunchImage.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Creates and saves a Launch Image asset catalog
class LaunchImage: NSObject {

    /// Information about each image to generate.
    var images: [String: NSImage] = [:]

    /// The image information for the contents.json
    var json: ContentsJSON!

    // swiftlint:disable cyclomatic_complexity
    /// Generate the necessary images for the selected platforms.
    ///
    /// - Parameters:
    ///   - platforms: Platforms to generate the images for.
    ///   - portrait: The portrait image, provided by the user.
    ///   - landscape: The landscape image, provided by the user.
    /// - Throws: See LaunchImageError for possible values.
    func generateImagesForPlatforms(_ platforms: [String], fromPortrait portrait: NSImage?,
                                    andLandscape landscape: NSImage?) throws {
        // Unwrap both images.
        guard let portrait = portrait, let landscape = landscape else {
            throw LaunchImageError.missingImage
        }
        // Get the JSON data for LaunchImage.
        json = try ContentsJSON(forType: AssetType.launchImage, andPlatforms: platforms)

        // Loop through the image data.
        for imgData in json.images {
            // Get the expected width.
            guard let width = imgData["expected-width"] else {
                throw LaunchImageError.missingDataForImageWidth
            }
            // Get the expected height.
            guard let height = imgData["expected-height"] else {
                throw LaunchImageError.missingDataForImageHeight
            }
            // Get the filename.
            guard let filename = imgData["filename"] else {
                throw LaunchImageError.missingDataForImageName
            }
            // Get the image orientation.
            guard let orientation = imgData["orientation"] else {
                throw LaunchImageError.missingDataForImageOrientation
            }
            // Get the idiom.
            guard let idiom = imgData["idiom"] else {
                throw LaunchImageError.missingDataForImageIdiom
            }

            // Is the current platform selected by the user?
            if platforms.contains(where: { $0.caseInsensitiveCompare(idiom) == .orderedSame }) {
                // Unwrap the width and height of the image
                guard let width = Int(width), let height = Int(height) else {
                    throw LaunchImageError.formatError
                }

                // Check which image to create. And crop the original image to the required size.
                switch ImageOrientation(rawValue: orientation)! {
                case ImageOrientation.Portrait:
                    images[filename] = portrait.imageByCroppingToSize(NSSize(width: width, height: height))

                case ImageOrientation.Landscape:
                    images[filename] = landscape.imageByCroppingToSize(NSSize(width: width, height: height))
                }
            }
        }
    }

    /// Write the Launch Image to the supplied file url.
    ///
    /// - Parameters:
    ///   - name: The name of the asset catalog.
    ///   - url: The URL to save the catalog to.
    /// - Throws: See NSImageExtensionError for possible values.
    func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
        // Create the correct file path.
        let url = url.appendingPathComponent("\(launchImageDir)/\(name).launchimage/",
                                             isDirectory: true)

        // Create the necessary folders.
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)

        // Save the Contents.json
        try json.saveToURL(url)
        for (filename, img) in images {
            try img.saveAsPNGFileToURL(url.appendingPathComponent(filename))
        }

        // Reset the images array
        self.images = [:]
    }
}
