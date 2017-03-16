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
    func generateScaledImagesFromImage(_ image: NSImage) {
        // Define the new image sizes.
        let x1 = NSSize(width: ceil(image.width / 3), height: ceil(image.height / 3))
        let x2 = NSSize(width: ceil(image.width / 1.5), height: ceil(image.height / 1.5))

        // Calculate the 2x and 1x images.
        images["1x"] = image.resize(withSize: x1)
        images["2x"] = image.resize(withSize: x2)

        // Assign the original images as the 3x image.
        images["3x"] = image
    }

    /// Write the Image Set to the supplied file url.
    ///
    /// - Parameters:
    ///   - name: The name of the asset catalog.
    ///   - url: The URL to save the catalog to.
    /// - Throws: See ImageSetError for possible values.
    func saveAssetCatalogNamed(_ name: String, toURL url: URL) throws {
        // Create the correct file path.
        let url = url.appendingPathComponent("\(imageSetDir)/\(name).imageset", isDirectory: true)
        // Create the necessary folders.
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true,
                                                attributes: nil)

        // Manage the Contents.json with an empty platforms array since we don't care
        // about platforms for Image Sets.
        var jsonFile = try ContentsJSON(forType: AssetType.imageSet, andPlatforms: [""])
        // Save the Contents.json to the HD.
        try jsonFile.saveToURL(url)

        // Loop through the image data.
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

        // Reset the images array
        self.images = [:]
    }
}
