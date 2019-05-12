//
// ImageOrientation.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

///  Possible image orientations
enum ImageOrientation: String {
    case portrait
    case landscape
    case all

    //used to generate .json filename
    var suffix: String {
        switch self {
        case .portrait:  return "_Portrait"
        case .landscape: return "_Landscape"
        case .all: return ""
        }
    }
}
