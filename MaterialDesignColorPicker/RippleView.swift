//
//  RippleView.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 2/5/17.
//  Copyright © 2017 CodeCatalyst. All rights reserved.
//

import Cocoa

class RippleView: NSView {
    var rippleColor: NSColor?

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
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        guard let color = rippleColor else {
            return
        }

        let mouseDownPoint = convert(event.locationInWindow, from: nil)

        ripple(color: color, from: mouseDownPoint)
    }
}
