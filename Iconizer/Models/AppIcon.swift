//
// AppIcon.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

class AppIcon: Codable {
    private static let marketing = "marketing"

    class var directory: String {
        return Constants.Directory.appIcon
    }

    class var `extension`: String {
        return Constants.AssetExtension.appIcon
    }

    let idiom: String
    let size: AssetSize
    let scale: AssetScale
    let role: String?       //Apple Watch
    let subtype: String?    //Apple Watch
    let platform: String?   //iMessage

    var filename: String {
        let scaledWidth = Int(size.width * Float(scale.value))
        return "icon-\(scaledWidth).png"
    }

    private enum ReadKeys: String, CodingKey {
        case idiom
        case size
        case scale
        case role
        case subtype
        case platform
    }

    private enum WriteKeys: String, CodingKey {
        case idiom
        case size
        case scale
        case role
        case subtype
        case platform
        case filename
    }

    init(idiom: String, size: AssetSize, scale: AssetScale, role: String? = nil,
         subtype: String? = nil, platform: String?) {
        self.idiom = idiom
        self.size = size
        self.scale = scale
        self.role = role
        self.subtype = subtype
        self.platform = platform
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ReadKeys.self)
        let idiom = try container.decode(String.self, forKey: .idiom)

        guard let scale = AssetScale(rawValue: try container.decode(String.self, forKey: .scale)) else {
            throw AssetCatalogError.invalidFormat(format: .scale)
        }
        let size = try AssetSize(size: try container.decode(String.self, forKey: .size))

        self.idiom = idiom
        self.size = size
        self.scale = scale

        self.role = try container.decodeIfPresent(String.self, forKey: .role)
        self.subtype = try container.decodeIfPresent(String.self, forKey: .subtype)
        self.platform = try container.decodeIfPresent(String.self, forKey: .platform)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WriteKeys.self)
        try container.encode(idiom, forKey: .idiom)
        try container.encode(size.name, forKey: .size)
        try container.encode(scale.rawValue, forKey: .scale)
        try container.encode(filename, forKey: .filename)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(subtype, forKey: .subtype)
        try container.encodeIfPresent(platform, forKey: .platform)
    }
}

extension AppIcon: Asset {
    static func resourceName(forPlatform platform: String) -> String {
        return "AppIcon_" + platform
    }

    static func directory(named: String) -> String {
        return "\(directory)/\(named).\(self.extension)"
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

        guard let resized = image.resize(toSize: size.multiply(scale), aspectMode: aspect ?? .fit) else {
            throw AssetCatalogError.rescalingImageFailed
        }
        //save to filesystem
        //no alpha for `ios-marketing` 1024x1024
        try resized.savePng(url: url, withoutAlpha: idiom.contains(AppIcon.marketing))
    }
}
