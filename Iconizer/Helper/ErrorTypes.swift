//
// ErrorTypes.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

///  Error Types for ContentsJSON.
///
///  - FileNotFound:                  The supplied JSON file could not be found.
///  - CastingJSONToDictionaryFailed: Casting the supplied JSON file to a Dictionary failed.
///  - GettingImagesArrayFailed:      Getting the information which images to generate failed.
///  - WritingContentsJSONFailed:     Saving the Contents.json for the asset catalog failed.
enum ContentsJSONError: Error {
    case fileNotFound
    case castingJSONToDictionaryFailed
    case gettingImagesArrayFailed
    case writingContentsJSONFailed
}

///  Error Types for ImageSet.
///
///  - RescalingImageFailed:           Rescaling the given image failed.
///  - GettingJSONDataFailed:          Getting image information from the given JSON file failed.
///  - MissingImage:                   The user didn't supply an image.
///  - GettingPNGRepresentationFailed: Creating the png representation failed.
enum ImageSetError: Error {
    case rescalingImageFailed
    case gettingJSONDataFailed
    case missingImage
    case gettingPNGRepresentationFailed
    case selectedImageNotFound
}

///  Error Types for LaunchImage.
///
///  - MissingImage:                   The user didn't supply an image.
///  - MissingDataForImageWidth:       Missing information about the width for the new image.
///  - MissingDataForImageHeight:      Missing information about the height for the new image.
///  - MissingDataForImageName:        Missing information about the name for the new image.
///  - MissingDataForImageOrientation: Missing information about the orientation for the new image.
///  - MissingDataForImageIdiom:       Missing information about the idiom for the new image.
///  - FormatError:                    Image format error.
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
///  - MissingImage:            The user didn't supply an image.
///  - MissingDataForImageSize: Missing information about the size of the new image.
///  - MissingDataForImageName: Missing information about the name of the new image.
///  - FormatError:             Image format error.
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
/// - UnwrappingPNGRepresentationFailed: Getting the png rep. for the current image failed.
enum NSImageExtensionError: Error {
    case unwrappingPNGRepresentationFailed
}
