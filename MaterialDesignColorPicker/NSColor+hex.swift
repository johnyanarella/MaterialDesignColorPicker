//
//  NSColor+hex.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 1/8/17.
//  Copyright © 2017 CodeCatalyst. All rights reserved.
//

import Cocoa

public extension NSColor {
    public convenience init?(hex: UInt, alpha: CGFloat) {
        self.init(srgbRed: CGFloat( (hex & 0xFF0000) >> 16 ) / 255.0,
                  green:   CGFloat( (hex & 0x00FF00) >> 8  ) / 255.0,
                  blue:    CGFloat( (hex & 0x0000FF) >> 0  ) / 255.0,
                  alpha:   alpha)
    }

    public convenience init?(hex: UInt) {
        self.init(hex: hex, alpha: 1.0)
    }

    public convenience init?(hexString: String, alpha: CGFloat) {
        var hexString = hexString.replacingOccurrences(of: "#", with: "")
        if hexString.characters.count == 3 {
            hexString = hexString.characters.reduce("") { (result, character) -> String in
                return result + String(character) + String(character)
            }
        }

        guard hexString.characters.count == 6 else {
            return nil
        }
        guard let hex = UInt(hexString, radix: 16) else {
            return nil
        }

        self.init(hex: hex, alpha: alpha)
    }

    public convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }

    public var hex: UInt? {
        guard numberOfComponents == 4 else {
            return nil
        }

        let red = UInt(round(redComponent * 255))
        let green = UInt(round(greenComponent * 255))
        let blue = UInt(round(blueComponent * 255))

        return red << 16 | green << 8 | blue
    }

    public var hexString: String? {
        guard let hex = hex else {
            return nil
        }

        return String(format: "#%06x", hex)
    }
}
