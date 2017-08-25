//
// NSImageExtensions.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

extension NSImage {

    /// The height of the image.
    var height: CGFloat {
        return size.height
    }

    /// The width of the image.
    var width: CGFloat {
        return size.width
    }

    /// A PNG representation of the image.
    var PNGRepresentation: Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .png, properties: [:])
        }

        return nil
    }

    // MARK: Resizing

    /// Resize the image to the given size.
    ///
    /// - Parameter size: The size to resize the image to.
    /// - Returns: The resized image.
    func resize(withSize size: NSSize) -> NSImage? {
        // Create a new rect with given width and height
        let frame = NSRect(x: 0, y: 0, width: size.width, height: size.height)

        // Get the best representation for the given size.
        guard let rep = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        // Create an empty image with the given size.
        let img = NSImage(size: size, flipped: false, drawingHandler: { (_) -> Bool in

            if rep.draw(in: frame) {
                return true
            }

            return false
        })

        return img
    }

    /// Copy the image and resize it to the supplied size, while maintaining it's
    /// original aspect ratio.
    ///
    /// - Parameter size: The target size of the image.
    /// - Returns: The resized image.
    func resizeMaintainingAspectRatio(withSize size: NSSize) -> NSImage? {
        let newSize: NSSize

        let widthRatio = size.width / width
        let heightRatio = size.height / height

        if widthRatio > heightRatio {
            newSize = NSSize(width: floor(width * widthRatio),
                             height: floor(height * widthRatio))
        } else {
            newSize = NSSize(width: floor(width * heightRatio),
                             height: floor(height * heightRatio))
        }

        return resize(withSize: newSize)
    }

    // MARK: Cropping

    /// Resize the image, to nearly fit the supplied cropping size
    /// and return a cropped copy the image.
    ///
    /// - Parameter size: The size of the new image.
    /// - Returns: The cropped image.
    func crop(toSize: NSSize) -> NSImage? {
        // Resize the current image, while preserving the aspect ratio.
        guard let resized = self.resizeMaintainingAspectRatio(withSize: size) else {
            return nil
        }

        // Get some points to center the cropping area.
        let x = floor((resized.width - size.width) / 2)
        let y = floor((resized.height - size.height) / 2)
        // Create the cropping frame.
        let frame = NSMakeRect(x, y, size.width, size.height)

        // Get the best representation of the image for the given cropping frame.
        guard let rep = resized.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        // Create a new image with the new size
        let img = NSImage(size: size)
        defer { img.unlockFocus() }
        img.lockFocus()

        if rep.draw(in: NSMakeRect(0, 0, size.width, size.height),
                    from: frame,
                    operation: NSCompositingOperation.copy,
                    fraction: 1.0,
                    respectFlipped: false,
                    hints: [:]) {
            return img // Return the cropped image.
        }

        // Return nil in case anything fails.
        return nil
    }

    // MARK: Saving

    /// Save the images PNG representation the the supplied file URL:
    ///
    /// - Parameter url: The file URL to save the png file to.
    /// - Throws: An unwrappingPNGRepresentationFailed when the image has no png representation.
    func savePngTo(url: URL) throws {
        if let png = self.PNGRepresentation {
            try png.write(to: url, options: .atomicWrite)
        } else {
            throw NSImageExtensionError.unwrappingPNGRepresentationFailed
        }
    }
}
