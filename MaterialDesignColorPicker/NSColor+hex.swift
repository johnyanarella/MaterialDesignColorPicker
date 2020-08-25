//
//  NSColor+hex.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 1/8/17.
//  Copyright © 2017-2020 John Yanarella.
//

import Cocoa

public extension NSColor {
    convenience init?(hex: UInt, alpha: CGFloat) {
        // swiftlint:disable colon
        self.init(srgbRed: CGFloat( (hex & 0xFF0000) >> 16 ) / 255.0,
                  green:   CGFloat( (hex & 0x00FF00) >> 8  ) / 255.0,
                  blue:    CGFloat( (hex & 0x0000FF) >> 0  ) / 255.0,
                  alpha:   alpha)
    }

    convenience init?(hex: UInt) {
        self.init(hex: hex, alpha: 1.0)
    }

    convenience init?(hexString: String, alpha: CGFloat) {
        var hexString = hexString.replacingOccurrences(of: "#", with: "")
        if hexString.count == 3 {
            hexString = hexString.reduce("") { (result, character) -> String in
                return result + String(character) + String(character)
            }
        }

        guard hexString.count == 6 else {
            return nil
        }
        guard let hex = UInt(hexString, radix: 16) else {
            return nil
        }

        self.init(hex: hex, alpha: alpha)
    }

    convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }

    var hex: UInt? {
        guard numberOfComponents == 4 else {
            return nil
        }

        let red = UInt(round(redComponent * 255))
        let green = UInt(round(greenComponent * 255))
        let blue = UInt(round(blueComponent * 255))

        return red << 16 | green << 8 | blue
    }

    var hexString: String? {
        guard let hex = hex else {
            return nil
        }

        return String(format: "#%06x", hex)
    }
}
