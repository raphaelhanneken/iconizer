//
// MessagesIcon.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Foundation

//same logic as AppIcon but different folder
class MessagesIcon: AppIcon {
    override class var directory: String {
        return Constants.Directory.iMessageIcon
    }

    override class var `extension`: String {
        return Constants.AssetExtension.iMessageIcon
    }

    override var filename: String {
        let realSize = size.multiply(scale)
        return "icon-\(realSize.width)x\(realSize.height).png"
    }
}
