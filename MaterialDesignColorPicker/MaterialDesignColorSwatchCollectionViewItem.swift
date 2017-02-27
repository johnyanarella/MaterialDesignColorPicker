//
//  MaterialDesignColorSwatchCollectionViewItem.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 1/28/17.
//  Copyright © 2017 CodeCatalyst. All rights reserved.
//

import Cocoa

class MaterialDesignColorSwatchCollectionViewItem: NSCollectionViewItem {
    @IBOutlet fileprivate weak var label: NSTextField!
    @IBOutlet fileprivate weak var hexLabel: NSTextField!

    @IBOutlet fileprivate weak var selectionIndicator: NSView! {
        didSet {
            selectionIndicator.wantsLayer = true
        }
    }

    var color: MaterialDesignColor? {
        didSet {
            guard isViewLoaded else {
                return
            }
            guard let color = color else {
                return
            }
            guard let view = view as? RippleView else {
                return
            }

            label.stringValue = color.label
            label.textColor = color.labelColor

            hexLabel.stringValue = String(format: "#%06x", color.hex).uppercased()
            hexLabel.textColor = color.labelColor

            selectionIndicator.layer?.backgroundColor = color.labelColor?.cgColor

            view.layer?.backgroundColor = color.color.cgColor
            view.rippleColor = color.rippleColor
        }
    }

    override var isSelected: Bool {
        didSet {
            selectionIndicator.isHidden = !isSelected
        }
    }
}
