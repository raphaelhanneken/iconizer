//
// AppIcon.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Creates and saves an App Icon asset catalog.
class AppIcon: NSObject {

    /// The resized images.
    var images: [String: [String: NSImage?]] = [:]

    /// Generate the necessary images for the selected platforms.
    ///
    /// - Parameters:
    ///   - platforms: The platforms to generate icon for.
    ///   - image: The image to generate the icon from.
    /// - Throws: See AppIconError for possible values.
    func generateImagesForPlatforms(_ platforms: [String], fromImage image: NSImage) throws {
        // Loop through the selected platforms
        for platform in platforms {
            // Temporary dict to hold the generated images.
            var tmpImages: [String: NSImage?] = [:]

            // Create a new JSON object for the current platform.
            let jsonData = try ContentsJSON(forType: AssetType.appIcon, andPlatforms: [platform])

            for index in 0..<jsonData.images.count {
                let file = try jsonData.filenameAt(index)
                if images[file.name] == nil {
                    tmpImages[file.name] = image.resize(toSize: NSSize(width: file.size, height: file.size), aspectMode: .fit)
                }
            }

            // Write back the images to self.images
            images[platform] = tmpImages
        }
    }

    /// Writes the App Icon for all selected platforms to the supplied file url.
    ///
    /// - Parameters:
    ///   - name: The name of the asset catalog
    ///   - url: The URL to save the catalog to
    /// - Throws: An AppIconError
    func saveAssetCatalog(named name: String, toURL url: URL) throws {
        for (platform, images) in self.images {
            // Ignore pseudo platform iOS
            if platform == Platform.iOS.rawValue {
                continue
            }

            let saveUrl = url.appendingPathComponent("\(appIconDir)/\(platform)/\(name).appiconset",
                                                     isDirectory: true)

            try FileManager.default.createDirectory(at: saveUrl,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)

            var contentsJson = try ContentsJSON(forType: AssetType.appIcon, andPlatforms: [platform])
            try contentsJson.saveToURL(saveUrl)
            try self.saveAsset(images: images, toUrl: saveUrl)
        }

        self.images = [:]
    }

    /// Writes the App Icon for all selected platforms, as combined asset, to the supplied file url.
    ///
    /// - Parameters:
    ///   - name: The name of the asset catalog
    ///   - url: The URL to save the catalog to
    /// - Throws: An AppIconError
    func saveCombinedAssetCatalog(named name: String, toUrl url: URL) throws {
        let saveUrl = url.appendingPathComponent("\(appIconDir)/Combined/\(name).appiconset", isDirectory: true)

        for (_, images) in images {
            try FileManager.default.createDirectory(at: saveUrl,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)

            var contentsJson = try ContentsJSON(forType: AssetType.appIcon,
                                                andPlatforms: Array(self.images.keys))

            try contentsJson.saveToURL(saveUrl)
            try self.saveAsset(images: images, toUrl: saveUrl)
        }
        self.images = [:]
    }

    /// Saves the supplied images as png to the supplied file url
    ///
    /// - Parameters:
    ///   - images: The images to be saved
    ///   - url: The file URL to save the images to
    /// - Throws: See AppIconError and NSImageExtensionError
    private func saveAsset(images: [String: NSImage?], toUrl url: URL) throws {
        for (filename, image) in images {
            guard let img = image else {
                throw AppIconError.missingImage
            }
            if filename == "ios-marketing.png" {
                try img.savePngWithoutAlphaChannelTo(url: url.appendingPathComponent(filename, isDirectory: false))
            } else {
                try img.savePngTo(url: url.appendingPathComponent(filename, isDirectory: false))
            }
        }
    }
}
