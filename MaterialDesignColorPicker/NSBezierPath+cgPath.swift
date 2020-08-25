//
//  NSBezierPath+cgPath.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 1/21/17.
//  Copyright © 2017-2020 John Yanarella.
//

import Cocoa

public extension NSBezierPath {
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for index in 0 ..< self.elementCount {
            let type = self.element(at: index, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(
                    to: CGPoint(x: points[0].x, y: points[0].y)
                )
            case .lineTo:
                path.addLine(
                    to: CGPoint(x: points[0].x, y: points[0].y)
                )
            case .curveTo:
                path.addCurve(
                    to: CGPoint(x: points[2].x, y: points[2].y),
                    control1: CGPoint(x: points[0].x, y: points[0].y),
                    control2: CGPoint(x: points[1].x, y: points[1].y)
                )
            case .closePath:
                path.closeSubpath()
            @unknown default:
                break
            }
        }
        return path
    }
}
