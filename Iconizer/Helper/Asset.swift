//
// Asset.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

protocol Asset {
    static var resourcePrefix: String { get }
    static func directory(named: String) -> String

    func save(_ image: [ImageOrientation: NSImage], aspect: AspectMode?, to url: URL) throws
}

extension Asset {
    static func resourceURL(name: String) throws -> URL {

        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            throw AssetCatalogError.missingPlatformJSON
        }

        return URL(fileURLWithPath: path)
    }
}

extension Asset where Self: Decodable {
    static func images(forPlatform platform: Platform, orientation: ImageOrientation = .none) throws -> [Self] {
        //.json file
        let url = try resourceURL(name: resourcePrefix + platform.name(forOrientation: orientation))
        let data = try Data(contentsOf: url)
        //parse json
        let decoder = JSONDecoder()
        return try decoder.decode([Self].self, from: data)
    }
}
