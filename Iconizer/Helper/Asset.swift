//
// Asset.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

protocol Asset {
    static func resourceName(forPlatform platform: String) -> String
    static func directory(named: String) -> String

    func save(_ image: [ImageOrientation: NSImage], aspect: AspectMode?, to url: URL) throws
}

extension Asset {
    static func resourceURL(forPlatform platform: String) throws -> URL {
        let name = resourceName(forPlatform: platform)

        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            throw AssetCatalogError.missingPlatformJSON
        }

        return URL(fileURLWithPath: path)
    }
}

extension Asset where Self: Decodable {
    static func images(forPlatform platform: Platform, orientation: ImageOrientation? = nil) throws -> [Self] {
        //.json file
        let url = try resourceURL(forPlatform: platform.rawValue + (orientation?.suffix ?? ""))
        let data = try Data(contentsOf: url)
        //parse json
        let decoder = JSONDecoder()
        return try decoder.decode([Self].self, from: data)
    }
}

// swiftlint:disable identifier_name
enum AssetScale: String {
    case x1 = "1x"
    case x2 = "2x"
    case x3 = "3x"

    var value: Int {
        switch self {
        case .x1: return 1
        case .x2: return 2
        case .x3: return 3
        }
    }
}
// swiftlint:enable identifier_name

//(width)x(height)
//must be for scale x1
//ex.: 85.5x85.5
struct AssetSize {
    let name: String
    let width: Float
    let height: Float

    init(size: String) throws {
        let regex = "^([\\d\\.]+)x([\\d\\.]+)$"
        if let expression = try? NSRegularExpression(pattern: regex) {
            let range = NSRange(size.startIndex..<size.endIndex, in: size)

            var widthResult: Float?
            var heightResult: Float?

            expression.enumerateMatches(in: size, options: [], range: range) { (match, _, stop) in
                defer { stop.pointee = true }
                guard let match = match else { return }

                if match.numberOfRanges == 3,
                   let wRange = Range(match.range(at: 1), in: size),
                   let hRange = Range(match.range(at: 2), in: size) {

                    widthResult = Float(size[wRange])
                    heightResult = Float(size[hRange])
                }
            }

            if let width = widthResult, let height = heightResult {
                self.name = size
                self.width = width
                self.height = height
                return
            }
        }

        throw AssetCatalogError.invalidFormat(format: .size)
    }
}
