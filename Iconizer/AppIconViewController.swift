//
// AppIconViewController.swift
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

// Constants for each platform name.
private let kAppleWatchPlatformName = "Watch"
private let kIPadPlatformName       = "iPad"
private let kIPhonePlatformName     = "iPhone"
private let kOSXPlatformName        = "Mac"
private let kCarPlayPlatformName    = "Car"

///  Handles the AppIconView
class AppIconViewController: NSViewController {
    
     /// Export for Car Play?
    @IBOutlet weak var carPlay: NSButton!
     /// Export for iPad?
    @IBOutlet weak var iPad: NSButton!
     /// Export for iPhone?
    @IBOutlet weak var iPhone: NSButton!
     /// Export for OS X?
    @IBOutlet weak var osx: NSButton!
     /// Export for Apple Watch?
    @IBOutlet weak var watch: NSButton!
     /// Export as combined asset?
    @IBOutlet weak var combined: NSButton!
     /// Progress indicator.
    @IBOutlet weak var processing: NSProgressIndicator!
     /// Image Well.
    @IBOutlet weak var imageView: NSImageView!
    
     /// Which platforms are actually selected?
    var enabledPlatforms: [String] {
        get {
            // String array of selected platforms.
            var tmp: [String] = []
            if self.carPlay == NSOnState { tmp.append(kCarPlayPlatformName) }
            if self.iPad    == NSOnState { tmp.append(kIPadPlatformName) }
            if self.iPhone  == NSOnState { tmp.append(kIPhonePlatformName) }
            if self.osx     == NSOnState { tmp.append(kOSXPlatformName ) }
            
            return tmp
        }
    }
    
     /// Holds the AppIcon model
    let appIcon = AppIcon()
    
    override var nibName: String {
        return "AppIconView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    // MARK: - Methods
    
    ///  Tells the model to generate the required images.
    ///
    ///  :returns: Returns true on success, false on failure.
    func generateRequiredImages() -> Bool {
        // Unwrap the image from imageView
        if let image = self.imageView.image {
            // Check if at least one platform is selected.
            if self.enabledPlatforms.count > 0 {
                // Since we definetly can do something here,
                // start the progress indicator.
                self.toggleProgressIndicator()
                
                // Tell the model to generate it's images
                self.appIcon.generateImagesForPlatforms(self.enabledPlatforms, fromImage: image)
                
                // Finished generating images, so stop the progress indicator.
                self.toggleProgressIndicator()
                
                // We're alright here, so return true
                return true
            } else {
                // Whoops! We have no platforms.
                self.beginSheetModalWithMessage("No Platform!", andText: "You haven't selected any platforms yet.")
            }
        } else {
            // Oh snap! Forgot the image.
            self.beginSheetModalWithMessage("No Image!", andText: "You haven't dropped any image to convert.")
        }
        
        // We have a problem here, captain!
        return false
    }
    
    ///  Tells the model to save itself to the given url.
    ///
    ///  :param: url File path to save the asset catalog to.
    func saveToURL(url: NSURL) {
        if self.combined == NSOnState {
            self.appIcon.saveAssetCatalogToURL(url, asCombinedAsset: true)
        } else {
            self.appIcon.saveAssetCatalogToURL(url, asCombinedAsset: false)
        }
    }
    
    ///  Toggles the animation status and visibility of the progress indicator.
    func toggleProgressIndicator() {
        if self.processing.hidden {
            self.processing.startAnimation(self)
            self.processing.hidden = false
        } else {
            self.processing.hidden = true
            self.processing.stopAnimation(self)
        }
    }
    
    ///  Opens an NSAlert panel ontop of MainWindow.
    ///
    ///  :param: message messageText for the NSAlert.
    ///  :param: text    informativeText for the NSAlert.
    func beginSheetModalWithMessage(message: String, andText text: String) {
        // Create a new NSAlert message.
        let alert = NSAlert()
        
        // Configure the NSAlert.
        alert.messageText     = message
        alert.informativeText = text
        
        // Display!
        alert.beginSheetModalForWindow(self.view.window!, completionHandler: nil)
    }
}
