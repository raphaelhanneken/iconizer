//
// Platform.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Foundation

enum Platform: String {
    case watch = "Watch"
    case iPhone = "iPhone"
    case iPad = "iPad"
    case iOS = "iOS"
    case macOS = "Mac"
    case car = "Car"
    case undefined = ""

    func name(forOrientation orientation: ImageOrientation) -> String {
        switch self {
        case .iPhone, .iPad:
            return self.rawValue + orientation.suffix
        default:
            return self.rawValue
        }
    }
}
