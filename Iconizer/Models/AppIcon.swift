//
// AppIcon.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

struct AppIcon: Codable {
    private static let marketing = "ios-marketing"

    let idiom: String
    let size: AssetSize
    let scale: AssetScale
    let role: String?    //Apple Watch
    let subtype: String? //Apple Watch

    var filename: String {
        return "icon-\(pixelSize).png"
    }

    private var pixelSize: Int {
        return Int(size.width * Float(scale.value))
    }

    private enum ReadKeys: String, CodingKey {
        case idiom
        case size
        case scale
        case role
        case subtype
    }

    private enum WriteKeys: String, CodingKey {
        case idiom
        case size
        case scale
        case role
        case subtype
        case filename
    }

    init(idiom: String, size: AssetSize, scale: AssetScale, role: String? = nil, subtype: String? = nil) {
        self.idiom = idiom
        self.size = size
        self.scale = scale
        self.role = role
        self.subtype = subtype
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ReadKeys.self)
        let idiom = try container.decode(String.self, forKey: .idiom)

        guard let scale = AssetScale(rawValue: try container.decode(String.self, forKey: .scale)) else {
            throw AssetCatalogError.invalidFormat(format: .scale)
        }
        let size = try AssetSize(size: try container.decode(String.self, forKey: .size))

        guard size.width == size.height else {
            throw AssetCatalogError.invalidFormat(format: .size)
        }

        self.idiom = idiom
        self.size = size
        self.scale = scale

        self.role = try container.decodeIfPresent(String.self, forKey: .role)
        self.subtype = try container.decodeIfPresent(String.self, forKey: .subtype)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WriteKeys.self)
        try container.encode(idiom, forKey: .idiom)
        try container.encode(size.name, forKey: .size)
        try container.encode(scale.rawValue, forKey: .scale)
        try container.encode(filename, forKey: .filename)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(subtype, forKey: .subtype)
    }
}

extension AppIcon: Asset {
    static func resourceName(forPlatform platform: String) -> String {
        return "AppIcon_" + platform
    }

    static func directory(named: String) -> String {
        return "\(Constants.Directory.appIcon)/\(named).appiconset"
    }

    func save(_ image: [ImageOrientation: NSImage], aspect: AspectMode?, to url: URL) throws {
        guard let image = image[.none] else {
            throw AssetCatalogError.missingImage
        }

        //append filename to asset folder path
        let url = url.appendingPathComponent(filename, isDirectory: false)
        //skip if already exist
        //filename based on size, so we will reuse same images in Contents.json
        guard !FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        //resize icon
        let size = pixelSize
        guard let resized = image.resize(toSize: NSSize(width: size, height: size), aspectMode: aspect ?? .fit) else {
            throw AssetCatalogError.rescalingImageFailed
        }
        //save to filesystem
        //no alpha for `ios-marketing` 1024x1024
        try resized.savePng(url: url, withoutAlpha: idiom == AppIcon.marketing)
    }
}
