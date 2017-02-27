//
//  OverlayScroller.swift
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

public final class OverlayScroller: NSScroller {
    private var fadeOutWorkItem: DispatchWorkItem?

    public override init(frame: NSRect) {
        super.init(frame: frame)

        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    private func initialize() {
        updateTrackingAreas()
    }

    deinit {
        fadeOutWorkItem?.cancel()
    }

    private var trackingArea: NSTrackingArea?

    public override func updateTrackingAreas() {
        super.updateTrackingAreas()

        if let trackingArea = trackingArea {
            removeTrackingArea(trackingArea)
        }

        trackingArea = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInActiveApp, .mouseMoved], owner: self, userInfo: nil)

        if let trackingArea = trackingArea {
            addTrackingArea(trackingArea)
        }
    }

    public override func draw(_ dirtyRect: NSRect) {
        // Only draw the knob. drawRect: should only be invoked when overlay scrollers are not used
        drawKnob()
    }

    public override func drawKnobSlot(in slotRect: NSRect, highlight flag: Bool) {
        // Don't draw the background. Should only be invoked when using overlay scrollers
    }

    public override var floatValue: Float {
        didSet {
            animator().alphaValue = 1.0
            scheduleFadeOut()
        }
    }

    public override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)

        fadeOut()
    }

    public override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)

        fadeIn()
    }

    public override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)

        alphaValue = 1.0
    }

    private func scheduleFadeOut() {
        fadeOutWorkItem?.cancel()
        fadeOutWorkItem = DispatchWorkItem {
            self.fadeOut()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: fadeOutWorkItem!)
    }

    private func fadeOut() {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.3
            self.animator().alphaValue = 0.0
        })

        fadeOutWorkItem?.cancel()
    }

    private func fadeIn() {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.1
            self.animator().alphaValue = 1.0
        })

        fadeOutWorkItem?.cancel()
    }

    public override class func isCompatibleWithOverlayScrollers() -> Bool {
        return true
    }

    public class func zeroWidth() -> CGFloat {
        return 0.0
    }
}
