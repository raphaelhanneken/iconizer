//
// NSImageExtensions.swift
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

extension NSImage {
    
    /// Returns the height of the current image.
    var height: CGFloat {
        return self.size.height
    }
    
    /// Returns the width of the current image.
    var width: CGFloat {
        return self.size.width
    }
    
    ///  Copies the current image and resizes it to the size of the given NSSize.
    ///
    ///  :param: size The size of the image copy.
    ///
    ///  :returns: The resized image.
    func copyWithSize(size: NSSize) -> NSImage? {
        // Create a new rect with given width and height
        let frame    = NSMakeRect(0, 0, size.width, size.height)
        
        // Get the best representation for the new size.
        if let rep = self.bestRepresentationForRect(frame, context: nil, hints: nil) {
            // Create an empty NSImage with the given size.
            let img = NSImage(size: size)
            
            // Draw the image.
            img.lockFocus()
            rep.drawInRect(frame)
            img.unlockFocus()
            
            // Return the resized image
            return img
        }
        
        return nil
    }
    
    ///  Copies the current image and resizes it to the size of the given NSSize, while
    ///  maintaining the aspect ratio of the original image.
    ///
    ///  :param: size          The size of the new image.
    ///  :param: preserveRatio true/false Either maintain the aspect ratio or not.
    ///
    ///  :returns: The resized image.
    func resizeToSize(size: NSSize, whileMaintainingAspectRatio preserveRatio: Bool) -> NSImage? {
        var newSize = size
        
        if preserveRatio {
            let widthRatio  = size.width / self.width
            let heightRatio = size.height / self.height
            
            if widthRatio > heightRatio {
                newSize = NSSize(width: floor(self.width * widthRatio), height: floor(self.height * widthRatio))
            } else {
                newSize = NSSize(width: floor(self.width * heightRatio), height: floor(self.height * heightRatio))
            }
        }
        
        return self.copyWithSize(newSize)
    }
    
    ///  Crops an image to the given size.
    ///
    ///  :param: size The size of the new image.
    ///
    ///  :returns: Cropped image.
    func cropToSize(size: NSSize) -> NSImage? {
        // Resize the current image, while preserving the aspect ratio.
        let resized = self.resizeToSize(size, whileMaintainingAspectRatio: true)
        
        if let resized = resized {
            // Get some points to center the cropping area.
            let x = floor((resized.width - size.width) / 2)
            let y = floor((resized.height - size.height) / 2)
            
            // Create the cropping frame.
            let frame = NSMakeRect(x, y, size.width, size.height)
            
            // Get the image representation for the cropping frame.
            if let rep = resized.bestRepresentationForRect(frame, context: nil, hints: nil) {
                // Create a new image with the new size
                let img = NSImage(size: size)
                
                img.lockFocus()
                rep.drawInRect(NSMakeRect(0, 0, size.width, size.height),
                    fromRect: frame,
                    operation: NSCompositingOperation.CompositeCopy,
                    fraction: 1.0,
                    respectFlipped: false,
                    hints: [:])
                
                img.unlockFocus()
                
                return img
            }
        }
        
        return nil
    }
    
    ///  Builds a PNGRepresentation of the current image.
    ///
    ///  :returns: NSData object of the png representation.
    func PNGRepresentation() -> NSData? {
        // Create an empty NSBitmapImageRep.
        var bitmap: NSBitmapImageRep
        
        // Get an NSBitmapImageRep of the current image.
        self.lockFocus()
        bitmap = NSBitmapImageRep(focusedViewRect: NSMakeRect(0, 0, self.size.width, self.size.height))!
        self.unlockFocus()
        
        // Return NSPNGFileType representation of the bitmap object.
        return bitmap.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: [:])
    }
}
