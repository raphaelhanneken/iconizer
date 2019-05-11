//
// JSONFile.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Reads and writes the Contents.json files.
class AssetCatalog<T: Codable & Asset>: Encodable {
    /// The image information from <Asset>.json
    var images = [T]()

    //general information for Contents.json
    private let author = "Iconizer"
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    func addPlatform(_ platform: Platform, orientation: ImageOrientation? = nil) throws {
        let images = try T.images(forPlatform: platform, orientation: orientation)
        self.images.append(contentsOf: images)
    }

    /// Writes the App Icon for all selected platforms to the supplied file url.
    ///
    /// - Parameters:
    ///   - name: The name of the asset catalog
    ///   - url: The URL to save the catalog to
    /// - Throws: An AppIconError
    func saveAssetCatalog(named name: String, toURL url: URL, fromImage image: [ImageOrientation: NSImage], aspect: AspectMode? = nil) throws {
        let destination = url.appendingPathComponent(T.directory(named: name), isDirectory: true)
        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true, attributes: nil)

        for assetItem in images {
            try assetItem.save(image, aspect: aspect, to: destination)
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