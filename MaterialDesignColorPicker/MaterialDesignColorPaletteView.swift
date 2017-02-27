//
//  MaterialDesignColorPaletteView.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 1/21/17.
//  Copyright © 2017 CodeCatalyst. All rights reserved.
//

import Cocoa

protocol MaterialDesignColorPaletteViewDelegate: class {
    func didSelect(_ colorPaletteView: MaterialDesignColorPaletteView, colorGroup: MaterialDesignColorGroup, at: NSPoint)
}

class MaterialDesignColorPaletteView: NSView {
    weak var delegate: MaterialDesignColorPaletteViewDelegate?

    override var isFlipped: Bool {
        return true
    }

    override var isOpaque: Bool {
        return true
    }

    private static let rowCount = 2

    private var cellCount: Int {
        return MaterialDesignPalette.colorGroups.count
    }

    private var cellCountPerRow: Int {
        return Int(ceil(Double(cellCount) / Double(MaterialDesignColorPaletteView.rowCount)))
    }

    private var cellWidth: CGFloat {
        return bounds.width / CGFloat(cellCountPerRow)
    }

    private var cellHeight: CGFloat {
        return cellWidth
    }

    var selectedColorGroup: MaterialDesignColorGroup? {
        didSet {
            if oldValue != selectedColorGroup {
                needsDisplay = true
            }
        }
    }

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

    override func draw(_ dirtyRect: NSRect) {
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        for (colorIndex, colorGroup) in MaterialDesignPalette.colorGroups.enumerated() {
            let cellRow = Int(floor(Double(colorIndex) / Double(cellCountPerRow)))
            let cellColumn = colorIndex % cellCountPerRow

            let cellOrigin = CGPoint(x: cellWidth * CGFloat(cellColumn), y: cellHeight * CGFloat(cellRow))

            let cellFrame = NSRect(origin: cellOrigin, size: cellSize)
            let cellColor = colorGroup.primaryColor.color
            let isSelected = (selectedColorGroup == colorGroup)

            drawPaletteCell(frame: cellFrame, fillColor: cellColor, isSelected: isSelected)
        }
    }

    func drawPaletteCell(frame: NSRect, fillColor: NSColor, isSelected: Bool = false) {
        NSGraphicsContext.saveGraphicsState()

        let path = NSBezierPath(rect: frame)

        fillColor.set()
        path.fill()

        if isSelected {
            let strokeWidth = CGFloat(2.0)
            let strokePath = NSBezierPath(rect: frame.insetBy(dx: strokeWidth - 1.0, dy: strokeWidth - 1.0))
            let strokeColor = NSColor.white

            strokeColor.set()
            strokePath.lineWidth = strokeWidth
            strokePath.stroke()
        }

        NSGraphicsContext.restoreGraphicsState()
    }

    func colorGroup(at point: NSPoint) -> MaterialDesignColorGroup {
        let column = Int(floor(point.x / cellWidth))
        let row = Int(floor(point.y / cellHeight))
        let colorGroupIndex = (row * cellCountPerRow) + column

        return MaterialDesignPalette.colorGroups[colorGroupIndex]
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        let mouseDownPoint = convert(event.locationInWindow, from: nil)
        let colorGroupAtPoint = colorGroup(at: mouseDownPoint)
        selectedColorGroup = colorGroupAtPoint
        delegate?.didSelect(self, colorGroup: colorGroupAtPoint, at: event.locationInWindow)
    }
}
