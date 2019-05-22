//
// LaunchImage.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

class LaunchImage: Codable {
    let extent: String
    let idiom: String
    let subtype: String?
    let version: String?
    let orientation: ImageOrientation
    let scale: AssetScale

    // pre-scaled in json, manually added
    // swiftlint:disable:next todo
    // TODO: remove from json. Need calculation algorithm
    let size: AssetSize

    var filename: String {
        return "LaunchImage-\(size.string).png"
    }

    private enum ReadKeys: String, CodingKey {
        case extent
        case idiom
        case subtype
        case version = "minimum-system-version"
        case orientation
        case scale
        case size
    }

    private enum WriteKeys: String, CodingKey {
        case extent
        case idiom
        case subtype
        case version = "minimum-system-version"
        case orientation
        case scale
        case filename
    }

    required init(from decoder: Decoder) throws {
        let decoder = try decoder.container(keyedBy: ReadKeys.self)
        let extent = try decoder.decode(String.self, forKey: .extent)
        let idiom = try decoder.decode(String.self, forKey: .idiom)
        let orientationString = try decoder.decode(String.self, forKey: .orientation)
        let scaleString = try decoder.decode(String.self, forKey: .scale)
        let size = try AssetSize(size: try decoder.decode(String.self, forKey: .size))

        guard let orientation = ImageOrientation(rawValue: orientationString) else {
            throw AssetCatalogError.invalidFormat(format: .orientation)
        }

        guard let scale = AssetScale(rawValue: scaleString) else {
            throw AssetCatalogError.invalidFormat(format: .scale)
        }

        self.extent = extent
        self.idiom = idiom
        self.subtype = try decoder.decodeIfPresent(String.self, forKey: .subtype)
        self.version = try decoder.decodeIfPresent(String.self, forKey: .version)
        self.orientation = orientation
        self.scale = scale
        self.size = size
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WriteKeys.self)
        try container.encode(extent, forKey: .extent)
        try container.encode(idiom, forKey: .idiom)
        try container.encode(orientation.rawValue, forKey: .orientation)
        try container.encode(scale.rawValue, forKey: .scale)
        try container.encode(filename, forKey: .filename)

        try container.encodeIfPresent(subtype, forKey: .subtype)
        try container.encodeIfPresent(version, forKey: .version)
    }
}

extension LaunchImage: Asset {
    static let resourcePrefix = "LaunchImage_"

    static func directory(named: String) -> String {
        return "\(Constants.Directory.launchImage)/\(named).\(Constants.AssetExtension.launchImage)"
    }

    func save(_ image: [ImageOrientation: NSImage], aspect: AspectMode?, to url: URL) throws {
        guard let image = image[orientation] else {
            throw AssetCatalogError.missingImage
        }

        //append filename to asset folder path
        let url = url.appendingPathComponent(filename, isDirectory: true)
        //skip if already exist
        //filename based on size, so we will reuse same images in Contents.json
        guard !FileManager.default.fileExists(atPath: url.path) else {
            return
        }

        guard let resized = image.resize(toSize: NSSize(width: Int(size.width), height: Int(size.height)),
                aspectMode: aspect ?? .fit) else {
            throw AssetCatalogError.rescalingImageFailed
        }

        //save to filesystem, no alpha
        try resized.savePng(url: url, withoutAlpha: false)
    }
}
