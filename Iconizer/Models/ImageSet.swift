//
// ImageSet.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

class ImageSet: Codable {
    //scale of input image
    static let inputScale: CGFloat = 3

    let idiom: String
    let scale: AssetScale

    var filename: String {
        return "image@\(scale.rawValue).png"
    }

    private enum ReadKeys: String, CodingKey {
        case idiom
        case scale
    }

    private enum WriteKeys: String, CodingKey {
        case idiom
        case scale
        case filename
    }

    init(idiom: String, scale: AssetScale) {
        self.idiom = idiom
        self.scale = scale
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ReadKeys.self)
        let idiom = try container.decode(String.self, forKey: .idiom)

        guard let scale = AssetScale(rawValue: try container.decode(String.self, forKey: .scale)) else {
            throw AssetCatalogError.invalidFormat(format: .scale)
        }

        self.idiom = idiom
        self.scale = scale
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WriteKeys.self)
        try container.encode(idiom, forKey: .idiom)
        try container.encode(scale.rawValue, forKey: .scale)
        try container.encode(filename, forKey: .filename)
    }
}

extension ImageSet: Asset {
    static let resourcePrefix = "ImageSet"

    static func directory(named: String) -> String {
        return "\(Constants.Directory.imageSet)/\(named).\(Constants.AssetExtension.imageSet)"
    }

    func save(_ image: [ImageOrientation: NSImage], aspect: AspectMode?, to url: URL) throws {
        guard let image = image[.none] else {
            throw AssetCatalogError.missingImage
        }

        let url = url.appendingPathComponent(filename, isDirectory: false)

        let coef = CGFloat(scale.value) / ImageSet.inputScale
        let size = NSSize(width: ceil(image.size.width * coef), height: ceil(image.size.height * coef))
        guard let resized = image.resize(toSize: size, aspectMode: aspect ?? .fit) else {
            throw AssetCatalogError.rescalingImageFailed
        }

        try resized.savePng(url: url)
    }
}
