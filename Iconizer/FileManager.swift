//
//  FileController.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 06/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

class FileManager {
    
    var jsonFile: [String : AnyObject]        // Contains data for the Contents.json file
    
    
    init() {
        jsonFile = [:]
        
        // Add the default attributes to the json object
        jsonFile["author"]  = "Iconizer"
        jsonFile["version"] = 1
    }
    
    
    func saveImageAssetToDirectoryURL(url: NSURL?, usingImages images: [String : Array<[String : NSImage?]>], asCombinedAsset combinedAsset: Bool = false) {
        // Holds icon specific informations (e.g. filename and size), for all generated icons
        var jsonImageDataArray: Array<[String : String]> = []
        
        // Unwrap the given url object
        if let dirURL = url {
            // Loop through the selected platforms
            for (platform, icons) in images {
                // Append the correct file structure to the given url
                let iconsetURL: NSURL
                
                if combinedAsset == true {
                    // For a combined asset: Save the xcasset folder under "Iconizer Assets"...
                    iconsetURL = NSURL.fileURLWithPath("\(dirURL.path!)/Iconizer Assets/Images.xcassets/AppIcon.appiconset", isDirectory: true)!
                } else {
                    // ...otherwise save the xcasset folder into a platform specific directory
                    iconsetURL = NSURL.fileURLWithPath("\(dirURL.path!)/Iconizer Assets/\(platform)/Images.xcassets/AppIcon.appiconset", isDirectory: true)!
                }
                
                // Create the required directories
                NSFileManager.defaultManager().createDirectoryAtURL(iconsetURL, withIntermediateDirectories: true, attributes: nil, error: nil)
                
                // Loop through the icons array
                for iconDict in icons {
                    // Unwrap icon name and icon file from the icon dictionary
                    for (name, icon) in iconDict {
                        // Create the correct filename
                        let filename = "\(platform.lowercaseString)-\(name).tiff"
                        // Append the corresponding icon name to the url
                        let fileURL = iconsetURL.URLByAppendingPathComponent(filename, isDirectory: false)
                        
                        // Get TIFF representation of the current icon...
                        if let tiffRep = icon?.TIFFRepresentation {
                            // ...and write it to the filesystem
                            if tiffRep.writeToURL(fileURL, atomically: true) {
                                println("Successfully wrote file to: \(fileURL.path!).")
                            } else {
                                println("Writing file \(filename) to \(fileURL.path!) failed!")
                            }
                        }
                        
                        // Build the icon specific dictionary and append it to the icon data array
                        jsonImageDataArray.append(buildDataObjectForImageNamed(name, forPlatform: platform, sized: icon!.size))
                    }
                }
                
                // Append the informations of all icons, for the current platform, to the json file object...
                jsonFile["images"] = jsonImageDataArray
                // ...and save it to the given url as Contents.json
                writeJSONFileToURL(iconsetURL)
                
                // Unless we're creating an combined asset, reset the icon informations
                if combinedAsset == false {
                    jsonImageDataArray = []
                }
            }
        }
    }
    
    
    // Builds the icon specific dictionary, based on platform, size and filename. In which the filename have 
    // to conform the following pattern: <ROLE>-<SUBTYPE [if any]>@<SCALE>
    func buildDataObjectForImageNamed(name: String, forPlatform platform: String, sized size: NSSize) -> [String : String] {
        // Holds the icon information; Gets returned at the very end
        var jsonImageData: [String : String] = [:]
        
        // Set the filename property
        jsonImageData["filename"] = "\(platform.lowercaseString)-\(name).tiff"
        // Set the idion property
        jsonImageData["idiom"] = platform.lowercaseString
        
        // Special case Apple Watch: Determine which subtype and role the current icon is for
        // Either 42mm or 38mm
        if platform == "Watch" {
            if name.rangeOfString("42mm") != nil {
                jsonImageData["subtype"] = "42mm"
            } else if name.rangeOfString("38mm") != nil{
                jsonImageData["subtype"] = "38mm"
            }
            
            // Set the role (e.g. notificationCenter, appLauncher, ...)
            if let index = name.rangeOfString("-") {
                jsonImageData["role"] = name.substringToIndex(advance(index.endIndex, -1))
            }
        }
        
        // Determine which scale we're having here
        if name.rangeOfString("@2x") != nil {
            jsonImageData["scale"] = "2x"
            
            // And again a special favor for Apple Watch: The icon for the notificationCenter, 42mm needs an image
            // size of 27.5px, the ONLY icon that needs and accepts a floating point number...
            if jsonImageData["subtype"] == "42mm" && jsonImageData["role"] == "notificationCenter" {
                // ...so we don't cast to Int here...
                jsonImageData["size"] = "\(size.width / 2)x\(size.height / 2)"
            } else {
                // ...but for everyone else
                jsonImageData["size"] = "\(Int(size.width / 2))x\(Int(size.height / 2))"
            }
            
        } else if name.rangeOfString("@3x") != nil {
            jsonImageData["scale"] = "3x"
            jsonImageData["size"] = "\(Int(size.width / 3))x\(Int(size.height / 3))"
        } else {
            jsonImageData["scale"] = "1x"
            jsonImageData["size"] = "\(Int(size.width))x\(Int(size.height))"
        }
        
        return jsonImageData
    }
    
    
    // Write the json object to the suitable url location
    func writeJSONFileToURL(url: NSURL) {
        // Append the file name to the given url
        let completeURL = url.URLByAppendingPathComponent("Contents.json", isDirectory: false)
        // Generate actual json data from the jsonFile object
        let jsonData    = NSJSONSerialization.dataWithJSONObject(jsonFile, options: nil, error: nil)
        
        // Unwrap the data object...
        if let json = jsonData {
            // and write them to the specified location
            json.writeToURL(completeURL, atomically: true)
        }
    }
}