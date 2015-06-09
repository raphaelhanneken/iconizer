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

///  Builds and saves the Contents.json for the given asset catalog.
class JSONFile : NSObject {
    
     ///  Author property of the contents.json
    let author = "Iconizer"
     ///  Version property of the contents.json
    let version = "1.0"
     ///  Holds the information for each image of the asset catalog.
    var images: [[String : String]] = []
     /// Holds the complete JSON object
    var data: [String : AnyObject]  = [:]
    
    
    ///  Builds a dictionary, for an app icon, with the needed image information.
    ///
    ///  :param: name     Name of the given image
    ///  :param: platform The platform this image was generated for
    ///  :param: size     The size of the given image
    ///
    ///  :returns: A dictionary with the necessary information for the contents.json
    func buildAppIconDictForImageNamed(name: String, forPlatform platform: String, sized size: NSSize) {
        // Holds the icon information; Gets appended to self.images.
        var imageData: [String : String] = [:]
        
        // Set the filename property.
        imageData["filename"] = name
        // Set the idiom property.
        imageData["idiom"] = platform.lowercaseString
        
        // Special case Apple Watch: Determine which subtype and role the current icon is for.
        // Either 42mm or 38mm.
        if platform == "Watch" {
            if name.rangeOfString("42mm") != nil {
                imageData["subtype"] = "42mm"
            } else if name.rangeOfString("38mm") != nil{
                imageData["subtype"] = "38mm"
            }
            
            // Extract the role (e.g. notificationCenter, appLauncher, and so on) from the filename.
            // Since we have filenames like "watch_appLauncher-38mm@2x.png", we want to extract the part 
            // between watch_ and -38mm...
            if let role = name.substringFromCharacter("_", to: "-") {
                // ...and set it as role.
                imageData["role"] = role
            }
        }
        
        // Determine which scale we're having here.
        if name.rangeOfString("@2x") != nil {
            imageData["scale"] = "2x"
            
            // And again a special favor for Apple Watch: The icon for the notificationCenter, 42mm needs an image
            // with the size of 27.5px, the ONLY icon that needs and accepts a floating point number...
            if imageData["subtype"] == "42mm" && imageData["role"] == "notificationCenter" {
                // ...so we don't cast to Int here...
                imageData["size"] = "\(size.width / 2)x\(size.height / 2)"
            } else {
                // ...but for every other image.
                imageData["size"] = "\(Int(size.width / 2))x\(Int(size.height / 2))"
            }
            
        } else if name.rangeOfString("@3x") != nil {
            imageData["scale"] = "3x"
            imageData["size"] = "\(Int(size.width / 3))x\(Int(size.height / 3))"
        } else {
            imageData["scale"] = "1x"
            imageData["size"] = "\(Int(size.width))x\(Int(size.height))"
        }
        
        // Append the imageData dictionary to the images array.
        self.images.append(imageData)
    }
    
    func buildImageSetDictForImageNamed(imageName: String, #scale: String) {
        // Holds the image information; Gets appended to self.images.
        var imageData: [String : String] = [:]
        
        // Set the idiom property to universal. It's the same for every image.
        imageData["idiom"] = "universal"
        
        // Set the scale
        imageData["scale"] = scale
        
        // Set the filename
        imageData["filename"] = imageName
        
        self.images.append(imageData)
    }
    
    ///  Writes the jsonData to the given file url.
    ///
    ///  :param: url File path to the folder to save the 'contents.json' to.
    func writeJSONFileToURL(url: NSURL) {
        // Append the file name to the given url
        let completeURL = url.URLByAppendingPathComponent("Contents.json", isDirectory: false)
        
        // Build the json data object.
        self.data["author"]  = self.author
        self.data["version"] = self.version
        self.data["images"]  = self.images

        // Generate actual json data from the jsonFile object
        let jsonData    = NSJSONSerialization.dataWithJSONObject(self.data, options: .PrettyPrinted, error: nil)
        
        // Unwrap the data object...
        if let json = jsonData {
            // and write them to the specified location
            json.writeToURL(completeURL, atomically: true)
        }
    }
}
