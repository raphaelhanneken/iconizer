//
// ImageOrientation.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

///  Possible image orientations for a launch image.
///
///  - Portrait:  Portrait image.
///  - Landscape: Landscape image.
enum ImageOrientation: String {
    case portrait
    case landscape
    case none

    var suffix: String {
        switch self {
        case .portrait:  return "_Portrait"
        case .landscape: return "_Landscape"
        case .none: return ""
        }
    }
}
