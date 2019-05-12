//
// AssetScale.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Foundation

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
