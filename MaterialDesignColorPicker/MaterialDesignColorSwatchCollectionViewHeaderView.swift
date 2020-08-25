//
//  MaterialDesignColorSwatchCollectionViewHeaderView.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 2/5/17.
//  Copyright © 2017-2020 John Yanarella.
//

import Cocoa

class MaterialDesignColorSwatchCollectionViewHeaderView: NSView {
    @IBOutlet fileprivate weak var nameLabel: NSTextField!

    override init(frame: NSRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    private func initialize() {
        wantsLayer = true
        layerContentsRedrawPolicy = .duringViewResize
    }

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
