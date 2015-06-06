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
    
    ///  Copies the current image and resizes it to the size of the given NSSize.
    ///
    ///  :param: size The size of the image copy.
    ///
    ///  :returns: The resized image.
    func copyWithSize(size: NSSize) -> NSImage? {
        // Create a new rect with given width and height
        let frame    = NSMakeRect(0, 0, size.width, size.height)
        // Extract an image representation for the frame rect
        let imageRep = self.bestRepresentationForRect(frame, context: nil, hints: nil)
        // Create an empty NSImage with the given size
        let newImage = NSImage(size: size)
        
        // Draw the newly sized image
        newImage.lockFocus()
        imageRep?.drawInRect(frame)
        newImage.unlockFocus()
        
        // Return the resized image
        return newImage
    }
    
    ///  Copies the current image and resizes it to the given width and height.
    ///
    ///  :param: width  The width of the image copy.
    ///  :param: height The height of the image copy.
    ///
    ///  :returns: The resized image.
    func copyWithWidth(width: Double, height: Double) -> NSImage? {
        let size = NSSize(width: width, height: height)
        return self.copyWithSize(size)
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
