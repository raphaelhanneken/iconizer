//
// ErrorTypes.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

///  Error Types for AssetCatalog.
///
///  - rescalingImageFailed:           Rescaling the given image failed.
///  - gettingJSONDataFailed:          Getting image information from the given JSON file failed.
///  - fileNotFound:                  The supplied JSON file could not be found.
///  - castingJSONToDictionaryFailed: Casting the supplied JSON file to a Dictionary failed.
///  - gettingImagesArrayFailed:      Getting the information which images to generate failed.
///  - writingContentsJSONFailed:     Saving the Contents.json for the asset catalog failed.
enum AssetCatalogError: Error {
    enum Format {
        case size, scale, orientation
    }
    case missingImage
    case rescalingImageFailed
    case gettingJSONDataFailed
    case invalidFormat(format: Format)
    case missingPlatformJSON
}

/// Error Types for the IconizerViewControllerProtocol
///
/// - missingImage:    The user didn't supply an image.
/// - missingPlatform: The user didn't select a platform.
enum IconizerViewControllerError: Error {
    case missingImage
    case missingPlatform
    case missingAspectMode
    case selectedImageNotFound
}

/// Error types for NSImageExtension
///
/// - unwrappingPNGRepresentationFailed: Getting the png rep. for the current image failed.
enum NSImageExtensionError: Error {
    case unwrappingPNGRepresentationFailed
}
