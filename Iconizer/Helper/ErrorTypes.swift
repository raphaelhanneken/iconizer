//
// ErrorTypes.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Raphael Hanneken
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


/// Error Types for ContentsJSON.swift
enum ContentsJSONError: ErrorType {
  case FileNotFound
  case CastingJSONToDictionaryFailed
  case GettingImagesArrayFailed
  case WritingContentsJSONFailed
}


/// Error Types for ImageSet.swift
enum ImageSetError: ErrorType {
  case RescalingImageFailed
  case GettingJSONDataFailed
  case MissingImage
  case GettingPNGRepresentationFailed
}


/// Error Types for LaunchImage.swift
enum LaunchImageError: ErrorType {
  case MissingImage
  case MissingDataForImageWidth
  case MissingDataForImageHeight
  case MissingDataForImageName
  case MissingDataForImageOrientation
  case MissingDataForImageIdiom
  case FormatError
}


/// Error Types for AppIcon.swift
enum AppIconError: ErrorType {
  case MissingImage
  case MissingDataForImageSize
  case MissingDataForImageName
  case FormatError
}


/// Error types NSImageExtensions.swift
enum NSImageExtensionError: ErrorType {
  case UnwrappingPNGRepresentationFailed
}