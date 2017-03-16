//
// ErrorTypes.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

///  Error Types for ContentsJSON.
///
///  - fileNotFound:                  The supplied JSON file could not be found.
///  - castingJSONToDictionaryFailed: Casting the supplied JSON file to a Dictionary failed.
///  - gettingImagesArrayFailed:      Getting the information which images to generate failed.
///  - writingContentsJSONFailed:     Saving the Contents.json for the asset catalog failed.
enum ContentsJSONError: Error {
    case fileNotFound
    case castingJSONToDictionaryFailed
    case gettingImagesArrayFailed
    case writingContentsJSONFailed
}

///  Error Types for ImageSet.
///
///  - rescalingImageFailed:           Rescaling the given image failed.
///  - gettingJSONDataFailed:          Getting image information from the given JSON file failed.
///  - missingImage:                   The user didn't supply an image.
///  - gettingPNGRepresentationFailed: Creating the png representation failed.
enum ImageSetError: Error {
    case rescalingImageFailed
    case gettingJSONDataFailed
    case missingImage
    case gettingPNGRepresentationFailed
    case selectedImageNotFound
}

///  Error Types for LaunchImage.
///
///  - missingImage:                   The user didn't supply an image.
///  - missingDataForImageWidth:       Missing information about the width for the new image.
///  - missingDataForImageHeight:      Missing information about the height for the new image.
///  - missingDataForImageName:        Missing information about the name for the new image.
///  - missingDataForImageOrientation: Missing information about the orientation for the new image.
///  - missingDataForImageIdiom:       Missing information about the idiom for the new image.
///  - formatError:                    Image format error.
enum LaunchImageError: Error {
    case missingImage
    case missingDataForImageWidth
    case missingDataForImageHeight
    case missingDataForImageName
    case missingDataForImageOrientation
    case missingDataForImageIdiom
    case formatError
    case selectedImageNotFound
}

///  Error Types for AppIcon
///
///  - missingImage:            The user didn't supply an image.
///  - missingDataForImageSize: Missing information about the size of the new image.
///  - missingDataForImageName: Missing information about the name of the new image.
///  - formatError:             Image format error.
enum AppIconError: Error {
    case missingImage
    case missingDataForImageSize
    case missingDataForImageName
    case formatError
    case selectedImageNotFound
}

/// Error Types for the IconizerViewControllerProtocol
///
/// - missingImage:    The user didn't supply an image.
/// - missingPlatform: The user didn't select a platform.
enum IconizerViewControllerError: Error {
    case missingImage
    case missingPlatform
}

/// Error types for NSImageExtension
///
/// - unwrappingPNGRepresentationFailed: Getting the png rep. for the current image failed.
enum NSImageExtensionError: Error {
    case unwrappingPNGRepresentationFailed
}
