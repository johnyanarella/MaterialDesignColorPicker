//
//  NSView+ripple.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 1/21/17.
//  Copyright © 2017 CodeCatalyst. All rights reserved.
//

import Cocoa

public extension NSView {
    public func ripple(color: NSColor, from: CGPoint, transition: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        guard let layer = layer else {
            return
        }

        let rippleLayer = RippleLayer()
        layer.addSublayer(rippleLayer)

        rippleLayer.ripple(color: color.cgColor, from: from, bounds: bounds, transition: transition, completion: completion)
    }
}

private func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
    return hypot(from.x - to.x, from.y - to.y)
}

private final class RippleLayer: CAShapeLayer {
    private func calculateRippleRadius(from: CGPoint, bounds: CGRect) -> CGFloat {
        return max(
            CGPointDistance(from: from, to: CGPoint(x: bounds.minX, y: bounds.minY)),
            CGPointDistance(from: from, to: CGPoint(x: bounds.maxX, y: bounds.minY)),
            CGPointDistance(from: from, to: CGPoint(x: bounds.maxX, y: bounds.maxY)),
            CGPointDistance(from: from, to: CGPoint(x: bounds.minX, y: bounds.maxY))
        )
    }

    fileprivate func ripple(color: CGColor, from: CGPoint, bounds: CGRect, transition: (() -> Void)?, completion: (() -> Void)?) {
        let radius = calculateRippleRadius(from: from, bounds: bounds)

        let circlePath = NSBezierPath()
        circlePath.appendArc(withCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        fillColor = color
        path = circlePath.cgPath
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        position = from

        let scaleUpAnimationDuration = 0.375
        let fadeOutAnimationDuration = 0.195

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.removeFromSuperlayer()
            self.removeAllAnimations()
            completion?()
        })

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            transition?()
        })

        let scaleUpAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleUpAnimation.fromValue = 0.0
        scaleUpAnimation.toValue = 1.0
        scaleUpAnimation.duration = scaleUpAnimationDuration
        scaleUpAnimation.timingFunction = MaterialDesignEasingCurves.fastOutSlowIn
        scaleUpAnimation.fillMode = kCAFillModeForwards
        scaleUpAnimation.isRemovedOnCompletion = false
        add(scaleUpAnimation, forKey: nil)

        CATransaction.commit()

        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.duration = fadeOutAnimationDuration
        fadeOutAnimation.beginTime = CACurrentMediaTime() + scaleUpAnimationDuration
        fadeOutAnimation.timingFunction = MaterialDesignEasingCurves.fastOutLinearIn
        fadeOutAnimation.fillMode = kCAFillModeForwards
        fadeOutAnimation.isRemovedOnCompletion = false
        add(fadeOutAnimation, forKey: nil)

        CATransaction.commit()
    }
}
