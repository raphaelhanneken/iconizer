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
            self.images += JSONObjectForType(type, andPlatform: platform)
        }
    }
    
    ///  Gets the JSON data for the given AssetType.
    ///
    ///  - parameter type: AssetType to get the json file for.
    ///
    ///  - returns: The JSON data for the given AssetType.
    func JSONObjectForType(type: AssetType, andPlatform platform: String) -> Array<[String : String]> {
        // Holds the path to the required JSON file.
        let path : String?
        
        // Get the correct JSON file for the given AssetType.
        switch (type) {
            case .AppIcon:
                path = NSBundle.mainBundle().pathForResource("AppIcon_" + platform, ofType: "json")
                
            case .ImageSet:
                path = NSBundle.mainBundle().pathForResource("ImageSet", ofType: "json")
                
            case .LaunchImage:
                path = NSBundle.mainBundle().pathForResource("LaunchImage_" + platform, ofType: "json")
        }
        
        // Unwrap the JSON file path.
        if let path = path {
            // Create a new NSData object from the contents of the selected JSON file.
            if let data = NSData(contentsOfFile: path) {
                // Create a new JSON object from the given data and cast it to a Dictionary.
                var json: AnyObject? = nil
                
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                } catch _ {
                    
                }
                
                if let json = json as? Dictionary<String, AnyObject> {
                    // Get the image information as Array.
                    if let images = json["images"] as? Array<[String : String]> {
                        // Return the new array with image information.
                        return images
                    }
                }
            }
        }
        
        return []
    }
    
    ///  Saves the Contents.json to the appropriate folder.
    ///
    ///  - parameter url: File url to save the Contents.json to.
    mutating func saveToURL(url: NSURL) {
        // Add the images to the contents dictionaries.
        self.contents["images"]  = self.images
        
        // Serialize the contents as JSON object.
        let JSONData: NSData?
        do {
            JSONData = try NSJSONSerialization.dataWithJSONObject(self.contents, options: .PrettyPrinted)
        } catch _ {
            JSONData = nil
        }
        
        // Save the JSON object to the HD.
        if let data = JSONData {
            data.writeToURL(url.URLByAppendingPathComponent("Contents.json", isDirectory: false), atomically: true)
        }
    }
}
