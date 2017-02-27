//
//  OverlayScrollView.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 2/5/17.
//  Copyright © 2017 CodeCatalyst. All rights reserved.
//
//  Swift port of:
//
//  RFOverlayScrollView
//  https://github.com/rheinfabrik/RFOverlayScrollView
//
//  Created by Tim Brückmann on 30.12.12.
//  Copyright (c) 2012 Rheinfabrik. All rights reserved.

import Cocoa

public class OverlayScrollView: NSScrollView {
    private var headerOffset: CGFloat = 0

    public override init(frame: NSRect) {
        super.init(frame: frame)

        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    private func initialize() {
        wantsLayer = true
        headerOffset = tableHeaderOffsetFromSuperview()
    }

    public override func tile() {
        // Fake zero scroller width so the contentView gets drawn to the edge
        method_exchangeImplementations(
            class_getClassMethod(OverlayScroller.self, #selector(OverlayScroller.scrollerWidth(for:scrollerStyle:))),
            class_getClassMethod(OverlayScroller.self, #selector(OverlayScroller.zeroWidth))
        )
        super.tile()
        // Restore original scroller width
        method_exchangeImplementations(
            class_getClassMethod(OverlayScroller.self, #selector(OverlayScroller.scrollerWidth(for:scrollerStyle:))),
            class_getClassMethod(OverlayScroller.self, #selector(OverlayScroller.zeroWidth))
        )

        if let verticalScroller = verticalScroller {
            let width = OverlayScroller.scrollerWidth(for: verticalScroller.controlSize, scrollerStyle: verticalScroller.scrollerStyle)

            verticalScroller.frame = NSRect(
                x: bounds.size.width - width,
                y: headerOffset,
                width: width,
                height: bounds.size.height - headerOffset
            )

            sortSubviews({ (view1, view2, context) -> ComparisonResult in
                if view1.isKind(of: OverlayScroller.self) {
                    return .orderedDescending
                }
                if view2.isKind(of: OverlayScroller.self) {
                    return .orderedAscending
                }
                return .orderedSame
            }, context: nil)
        }
    }

    private func tableHeaderOffsetFromSuperview() -> CGFloat {
        for subview in subviews {
            if subview.isKind(of: NSClipView.self) {
                for clipViewSubview in subview.subviews {
                    if let tableView = clipViewSubview as? NSTableView, let headerView = tableView.headerView {
                        return headerView.frame.size.height
                    }
                }
            }
        }
        return 0
    }
}
