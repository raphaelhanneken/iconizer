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

    /// Rezise the image to fit the target size, without cropping the image.
    ///
    /// - Parameter targetSize: The size of the new image
    /// - Returns: The resized image
    func aspectFit(toSize targetSize: NSSize) -> NSImage? {
        let widthRatio  = targetSize.width / self.width
        let heightRatio = targetSize.height / self.height
        var newSize     = NSSize(width: floor(self.width * widthRatio), height: floor(self.height * widthRatio))

        if widthRatio > heightRatio {
            newSize = NSSize(width: floor(self.width * heightRatio),
                             height: floor(self.height * heightRatio))
        }

        guard let resizedImage = self.resize(toSize: newSize) else {
            return nil
        }
        let xCoordinate = floor((resizedImage.width - targetSize.width) / 2)
        let yCoordinate = floor((resizedImage.height - targetSize.height) / 2)
        let frame       = NSRect(x: xCoordinate, y: yCoordinate, width: targetSize.width, height: targetSize.height)

        guard let representation = resizedImage.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        let newImage = NSImage(size: targetSize, flipped: false) { (destinationRect: NSRect) -> Bool in
            return representation.draw(in: destinationRect,
                                       from: frame,
                                       operation: .copy,
                                       fraction: 1.0,
                                       respectFlipped: false,
                                       hints: nil)
        }

        return newImage
    }

    // MARK: Cropping

    /// Rezise the image to fit the target size, cropping part of the image if necessary.
    ///
    /// - Parameter size: The size of the new image.
    /// - Returns: The cropped image.
    func aspectFill(toSize targetSize: NSSize) -> NSImage? {
        guard let resizedImage = self.resizeMaintainingAspectRatio(withSize: targetSize) else {
            return nil
        }

        let xCoordinate = floor((resizedImage.width - targetSize.width) / 2)
        let yCoordinate = floor((resizedImage.height - targetSize.height) / 2)
        let frame       = NSRect(x: xCoordinate, y: yCoordinate, width: targetSize.width, height: targetSize.height)

        guard let representation = resizedImage.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        let image = NSImage(size: targetSize,
                            flipped: false,
                            drawingHandler: { (destinationRect: NSRect) -> Bool in
            return representation.draw(in: destinationRect,
                                       from: frame,
                                       operation: .copy,
                                       fraction: 1.0,
                                       respectFlipped: false,
                                       hints: nil)
        })

        return image
    }

    /// Resize the image to the given size.
    ///
    /// - Parameter size: The size to resize the image to.
    /// - Returns: The resized image.
    func resize(toSize targetSize: NSSize) -> NSImage? {
        let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
            return representation.draw(in: frame)
        })

        return image
    }

    /// Copy the image and resize it to the supplied size, while maintaining it's
    /// original aspect ratio.
    ///
    /// - Parameter size: The target size of the image.
    /// - Returns: The resized image.
    private func resizeMaintainingAspectRatio(withSize targetSize: NSSize) -> NSImage? {
        let newSize: NSSize
        let widthRatio  = targetSize.width / self.width
        let heightRatio = targetSize.height / self.height

        if widthRatio > heightRatio {
            newSize = NSSize(width: floor(self.width * widthRatio),
                             height: floor(self.height * widthRatio))
        } else {
            newSize = NSSize(width: floor(self.width * heightRatio),
                             height: floor(self.height * heightRatio))
        }
        return self.resize(toSize: newSize)
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
