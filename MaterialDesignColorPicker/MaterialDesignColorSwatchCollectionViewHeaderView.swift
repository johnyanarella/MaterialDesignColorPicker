//
//  MaterialDesignColorSwatchCollectionViewHeaderView.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 2/5/17.
//  Copyright © 2017 CodeCatalyst. All rights reserved.
//

import Cocoa

class MaterialDesignColorSwatchCollectionViewHeaderView: NSView {
    @IBOutlet fileprivate weak var nameLabel: NSTextField!

    var colorGroup: MaterialDesignColorGroup? {
        didSet {
            guard let colorGroup = colorGroup else {
                return
            }

            let color = colorGroup.primaryColor

            nameLabel.stringValue = colorGroup.name
            nameLabel.textColor = color.labelColor

            layer?.backgroundColor = color.color.cgColor
        }
    }
}
