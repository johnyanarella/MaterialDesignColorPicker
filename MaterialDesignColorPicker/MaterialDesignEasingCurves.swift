//
//  MaterialDesignEasingCurves.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 1/21/17.
//  Copyright © 2017 CodeCatalyst. All rights reserved.
//

import Cocoa

struct MaterialDesignEasingCurves {
    static let fastOutSlowIn = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
    static let linearOutSlow = CAMediaTimingFunction(controlPoints: 0.0, 0.0, 0.2, 1.0)
    static let fastOutLinearIn = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 1.0, 1.0)
}
