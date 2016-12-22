//
// ErrorTypes.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Raphael Hanneken
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

/// Error types for NSImageExtension
///
/// - UnwrappingPNGRepresentationFailed: Getting the png rep. for the current image failed.
enum NSImageExtensionError: Error {
  case unwrappingPNGRepresentationFailed
}
