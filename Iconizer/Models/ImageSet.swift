//
// ImageSet.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Creates and saves an Image Set asset catalog.
class ImageSet: NSObject {

    /// The resized images.
    var images: [String: NSImage] = [:]

    /// Create the @1x and @2x images from the supplied image.
    ///
    /// - Parameter image: The image to resize.
    func generateScaledImagesFromImage(_ image: NSImage) throws {
        // Get the image size in pixels, as calculating with the width and height values of the NSImage
        // will produce wrong results. See GitHub issue #24
        guard let imageSize = image.sizeInPixels else {
            throw ImageSetError.rescalingImageFailed
        }

        let imageSize1x = NSSize(width: ceil(imageSize.width / 3), height: ceil(imageSize.height / 3))
        let imageSize2x = NSSize(width: imageSize1x.width * 2, height: imageSize1x.height * 2)

        images["1x"] = image.resize(toSize: imageSize1x, aspectMode: .fit)
        images["2x"] = image.resize(toSize: imageSize2x, aspectMode: .fit)
        images["3x"] = image
    }

    /// Write the Image Set to the supplied file url.
    ///
    /// - Parameters:
    ///   - name: The name of the asset catalog.
    ///   - url: The URL to save the catalog to.
    /// - Throws: See ImageSetError for possible values.
    func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
        let url = url.appendingPathComponent("\(imageSetDir)/\(name).imageset", isDirectory: true)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true,
                                                attributes: nil)

        // Manage the Contents.json with an empty platforms array since we don't care
        // about platforms for Image Sets.
        var jsonFile = try ContentsJSON(forType: AssetType.imageSet, andPlatforms: [""])
        for image in jsonFile.images {
            // Unwrap the information we need.
            guard let scale = image["scale"], let filename = image["filename"] else {
                throw ImageSetError.gettingJSONDataFailed
            }
            // Get the correct image.
            guard let img = self.images[scale] else {
                throw ImageSetError.missingImage
            }
            // Save the png representation to the supplied url.
            try img.savePngTo(url: url.appendingPathComponent(filename))
        }
        try jsonFile.saveToURL(url)
        images = [:]
    }
}
