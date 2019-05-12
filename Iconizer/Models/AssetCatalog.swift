//
// JSONFile.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Reads and writes the Contents.json files.
class AssetCatalog<T: Codable & Asset>: Encodable {
    /// The image information from <Asset>.json
    var items = [T]()

    //general information for Contents.json
    private let author = "Iconizer"
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    func add(_ platform: Platform, orientation: ImageOrientation = .none) throws {
        let images = try T.images(forPlatform: platform, orientation: orientation)
        items.append(contentsOf: images)
    }

    /// Writes the App Icon for all selected platforms to the supplied file url.
    ///
    /// - Parameters:
    ///   - name: The name of the asset catalog
    ///   - url: The URL to save the catalog to
    /// - Throws: An AppIconError
    func save(_ image: [ImageOrientation: NSImage], named: String, toURL url: URL,
              aspect: AspectMode? = nil) throws {
        let destination = url.appendingPathComponent(T.directory(named: named), isDirectory: true)
        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true, attributes: nil)

        for assetItem in items {
            //remove images from memory after it was saved
            try autoreleasepool {
                try assetItem.save(image, aspect: aspect, to: destination)
            }

        }

        try saveContentsJson(to: destination)
    }

    ///  Saves the Contents.json to the appropriate folder.
    ///
    ///  - parameter url: File url to save the Contents.json to.
    ///  - throws: An exception when the JSON serialization fails.
    /// Save the Contents.json to the supplied file URL.
    ///
    /// - Parameter url: The file URL to save the Contents.json to.
    /// - Throws: See EncodingError for possible values.
    private func saveContentsJson(to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        try data.write(to: url.appendingPathComponent("Contents.json", isDirectory: false), options: .atomic)
    }
}
