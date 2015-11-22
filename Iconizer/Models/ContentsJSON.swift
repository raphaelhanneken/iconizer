//
// JSONFile.swift
// Iconizer
// https://github.com/behoernchen/Iconizer
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

import Cocoa


/// Reads and writes the Contents JSON files.
struct ContentsJSON {
  /// Holds the image data from <AssetType>.json
  var images: Array<[String : String]>

  /// Holds the complete information required for Contents.json
  var contents: [String : AnyObject] = [:]


  // MARK: Initializers

  ///  Initializes the JSONData struct.
  ///
  ///  - returns: The initialized JSONData struct.
  init() {
    // Init the images array.
    self.images = []

    // Init the contents array, with general information.
    self.contents["author"]  = "Iconizer"
    self.contents["version"] = "1.0"
    self.contents["images"]  = []
  }

  ///  Initializes the JSONData struct with a specified AssetType and
  ///  selected platforms.
  ///
  ///  - parameter type: The AssetType for the required JSON data
  ///  - parameter platforms: Selected platforms
  ///
  ///  - returns: The initialized JSONData specified for an AssetType and platforms.
  init(forType type: AssetType, andPlatforms platforms: [String]) {
    // Basic initialization.
    self.init()

    // Initialize the data object.
    for platform in platforms {
      // Add the image information for each platform to our images array.
      do {
        images += try JSONObjectForType(type, andPlatform: platform)
      } catch {
        print(error)
      }
    }
  }


  // MARK: Methods

  ///  Gets the JSON data for the given AssetType.
  ///
  ///  - parameter type: AssetType to get the json file for.
  ///
  ///  - returns: The JSON data for the given AssetType.
  func JSONObjectForType(type: AssetType, andPlatform platform: String) throws -> Array<[String : String]> {
    // Holds the path to the required JSON file.
    let resourcePath : String?

    // Get the correct JSON file for the given AssetType.
    switch (type) {
    case .AppIcon:
      resourcePath = NSBundle.mainBundle().pathForResource("AppIcon_" + platform, ofType: "json")

    case .ImageSet:
      resourcePath = NSBundle.mainBundle().pathForResource("ImageSet", ofType: "json")

    case .LaunchImage:
      resourcePath = NSBundle.mainBundle().pathForResource("LaunchImage_" + platform, ofType: "json")
    }

    // Unwrap the JSON file path.
    guard let path = resourcePath else {
      throw ContentsJSONError.FileNotFound
    }

    // Create a new NSData object from the contents of the selected JSON file.
    let JSONData = try NSData(contentsOfFile: path, options: .DataReadingMappedAlways)

    // Create a new JSON object from the given data.
    let JSONObject = try NSJSONSerialization.JSONObjectWithData(JSONData, options: .AllowFragments)

    // Convert the JSON object into a Dictionary.
    guard let contentsDict = JSONObject as? Dictionary<String, AnyObject> else {
      throw ContentsJSONError.CastingJSONToDictionaryFailed
    }

    // Get the image information from the JSON dictionary.
    guard let images = contentsDict["images"] as? Array<[String : String]> else {
      throw ContentsJSONError.GettingImagesArrayFailed
    }

    // Return image information.
    return images
  }

  ///  Saves the Contents.json to the appropriate folder.
  ///
  ///  - parameter url: File url to save the Contents.json to.
  mutating func saveToURL(url: NSURL) throws {
    // Add the image information to the contents dictionary.
    contents["images"]  = images

    // Serialize the contents as JSON object.
    let data = try NSJSONSerialization.dataWithJSONObject(self.contents, options: .PrettyPrinted)

    // Write the JSON object to the HD.
    try data.writeToURL(url.URLByAppendingPathComponent("Contents.json", isDirectory: false), options: .DataWritingAtomic)
  }
}
