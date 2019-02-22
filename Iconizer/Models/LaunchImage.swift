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
    var json = ContentsJSON()

    // swiftlint:disable cyclomatic_complexity
    /// Generate the necessary images for the selected platforms.
    ///
    /// - Parameters:
    ///   - platforms: Platforms to generate the images for.
    ///   - portrait: The portrait image, provided by the user.
    ///   - landscape: The landscape image, provided by the user.
    /// - Throws: See LaunchImageError for possible values.
    func generateImagesForPlatforms(_ platforms: [String], fromPortrait portrait: NSImage?,
                                    andLandscape landscape: NSImage?, mode: AspectMode?) throws {
        if nil != portrait {
            let portraitImageData = try ContentsJSON(forType: .launchImage,
                                                     andPlatforms: platforms,
                                                     withOrientation: .portrait)

            json.images += portraitImageData.images
        }

        if nil != landscape {
            let landscapeImageData = try ContentsJSON(forType: .launchImage,
                                                      andPlatforms: platforms,
                                                      withOrientation: .landscape)

            json.images += landscapeImageData.images
        }

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

            guard let mode = mode else {
                throw LaunchImageError.formatError
            }

            // Is the current platform selected by the user?
            if platforms.contains(where: { $0.caseInsensitiveCompare(idiom) == .orderedSame }) {
                // Unwrap the width and height of the image
                guard let width = Int(width), let height = Int(height) else {
                    throw LaunchImageError.formatError
                }

                // Check which image to create. And crop the original image to the required size.
                switch ImageOrientation(rawValue: orientation)! {
                case ImageOrientation.portrait:
                    images[filename] = portrait?.resize(toSize: NSSize(width: width, height: height), aspectMode: mode)

                case ImageOrientation.landscape:
                    images[filename] = landscape?.resize(toSize: NSSize(width: width, height: height), aspectMode: mode)
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
        let url = url.appendingPathComponent("\(launchImageDir)/\(name).launchimage/", isDirectory: true)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        try json.saveToURL(url)
        for (filename, img) in images {
            try img.savePngWithoutAlphaChannelTo(url: url.appendingPathComponent(filename))
        }
        images.removeAll()
    }
}
