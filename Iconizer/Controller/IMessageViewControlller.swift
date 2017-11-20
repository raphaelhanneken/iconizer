//
//  IMessageViewControlller.swift
//  Iconizer
//
//  Created by Martin Kluska on 17.11.17.
//  Copyright © 2017 Raphael Hanneken. All rights reserved.
//

import Cocoa

class IMessageViewControlller: NSViewController, IconizerViewControllerProtocol {

    /// Holds the image view for the image to generate
    /// the Image Set from.
    @IBOutlet weak var imageView: NSImageView!
    
    /// Responsible for creating and saving the asset catalog.
    let icon = IMessageIcon()
    
    /// The name of the corresponding nib file.
    override var nibName: NSNib.Name {
        return NSNib.Name("IMessageView")
    }
    
    // MARK: Iconizer View Controller
    
    func generateRequiredImages() throws {
        guard let image = imageView.image else {
            throw IMessageError.missingImage
        }
        try icon.generateScaledImagesFromImage(image)
    }
    
    func saveAssetCatalog(named name: String, toURL url: URL) throws {
        try icon.saveAssetCatalogNamed(name, toURL: url)
    }
    
    func openSelectedImage(_ image: NSImage?) throws {
        guard let img = image else {
            throw IMessageError.selectedImageNotFound
        }
        imageView.image = img
    }
    
}
