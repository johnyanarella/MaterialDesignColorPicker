//
//  MaterialDesignColorPalette.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 1/8/17.
//  Copyright © 2017-2020 John Yanarella.
//

import Cocoa

enum MaterialDesignColorKind {
    case dark
    case light
}

struct MaterialDesignColor: Equatable {
    let hex: UInt
    let label: String
    var kind: MaterialDesignColorKind

    let color: NSColor

    init(hex: UInt, label: String, kind: MaterialDesignColorKind) {
        self.hex = hex
        self.label = label
        self.kind = kind

        self.color = NSColor(hex: hex)!
    }
}

func == (lhs: MaterialDesignColor, rhs: MaterialDesignColor) -> Bool {
    return lhs.hex == rhs.hex
        && lhs.label == rhs.label
        && lhs.kind == rhs.kind
}

struct MaterialDesignColorGroup: Equatable {
    let name: String
    let colors: [MaterialDesignColor]

    var primaryColor: MaterialDesignColor

    init(name: String, colors: [MaterialDesignColor]) {
        self.name = name
        self.colors = colors

        if let primaryColor = colors.first(where: { $0.label == "500" }) {
            self.primaryColor = primaryColor
        } else {
            self.primaryColor = colors[0]
        }
    }
}

func == (lhs: MaterialDesignColorGroup, rhs: MaterialDesignColorGroup) -> Bool {
    return lhs.name == rhs.name
        && lhs.colors == rhs.colors
}

extension MaterialDesignColorGroup {
    func color(for arbitraryColor: NSColor) -> MaterialDesignColor? {
        guard let srgbColor = arbitraryColor.usingColorSpace(.sRGB) else {
            return nil
        }

        return colors.first(where: {$0.hex == srgbColor.hex})
    }
}

extension MaterialDesignColor {
    private static let labelAlpha = CGFloat(0.87)

    private static let darkLabelColor = NSColor(hex: 0xffffff, alpha: MaterialDesignColor.labelAlpha)
    private static let lightLabelColor = NSColor(hex: 0x000000, alpha: MaterialDesignColor.labelAlpha)

    var labelColor: NSColor? {
        switch kind {
        case .dark:
            return MaterialDesignColor.darkLabelColor
        case .light:
            return MaterialDesignColor.lightLabelColor
        }
    }

    static let rippleAlpha = CGFloat(0.20)

    static let darkRippleColor = NSColor(hex: 0xffffff, alpha: rippleAlpha)
    static let lightRippleColor = NSColor(hex: 0x000000, alpha: rippleAlpha)

    var rippleColor: NSColor? {
        switch kind {
        case .dark:
            return MaterialDesignColor.darkRippleColor
        case .light:
            return MaterialDesignColor.lightRippleColor
        }
    }
}

// swiftlint:disable colon
struct MaterialDesignPalette {
    static let colorGroups = [
        MaterialDesignColorGroup(
            name: "Red",
            colors: [
                MaterialDesignColor(hex: 0xffebee, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xffcdd2, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xef9a9a, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0xe57373, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0xef5350, label:  "400", kind: .dark),
                MaterialDesignColor(hex: 0xf44336, label:  "500", kind: .dark),
                MaterialDesignColor(hex: 0xe53935, label:  "600", kind: .dark),
                MaterialDesignColor(hex: 0xd32f2f, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0xc62828, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0xb71c1c, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0xff8a80, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0xff5252, label: "A200", kind: .dark),
                MaterialDesignColor(hex: 0xff1744, label: "A400", kind: .dark),
                MaterialDesignColor(hex: 0xd50000, label: "A700", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Pink",
            colors: [
                MaterialDesignColor(hex: 0xfce4ec, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xf8bbd0, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xf48fb1, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0xf06292, label:  "300", kind: .dark),
                MaterialDesignColor(hex: 0xec407a, label:  "400", kind: .dark),
                MaterialDesignColor(hex: 0xe91e63, label:  "500", kind: .dark),
                MaterialDesignColor(hex: 0xd81b60, label:  "600", kind: .dark),
                MaterialDesignColor(hex: 0xc2185b, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0xad1457, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0x880e4f, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0xff80ab, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0xff4081, label: "A200", kind: .dark),
                MaterialDesignColor(hex: 0xf50057, label: "A400", kind: .dark),
                MaterialDesignColor(hex: 0xc51162, label: "A700", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Purple",
            colors: [
                MaterialDesignColor(hex: 0xf3e5f5, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xe1bee7, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xce93d8, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0xba68c8, label:  "300", kind: .dark),
                MaterialDesignColor(hex: 0xab47bc, label:  "400", kind: .dark),
                MaterialDesignColor(hex: 0x9c27b0, label:  "500", kind: .dark),
                MaterialDesignColor(hex: 0x8e24aa, label:  "600", kind: .dark),
                MaterialDesignColor(hex: 0x7b1fa2, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0x6a1b9a, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0x4a148c, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0xea80fc, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0xe040fb, label: "A200", kind: .dark),
                MaterialDesignColor(hex: 0xd500f9, label: "A400", kind: .dark),
                MaterialDesignColor(hex: 0xaa00ff, label: "A700", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Deep Purple",
            colors: [
                MaterialDesignColor(hex: 0xede7f6, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xd1c4e9, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xb39ddb, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0x9575cd, label:  "300", kind: .dark),
                MaterialDesignColor(hex: 0x7e57c2, label:  "400", kind: .dark),
                MaterialDesignColor(hex: 0x673ab7, label:  "500", kind: .dark),
                MaterialDesignColor(hex: 0x5e35b1, label:  "600", kind: .dark),
                MaterialDesignColor(hex: 0x512da8, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0x4527a0, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0x311b92, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0xb388ff, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0x7c4dff, label: "A200", kind: .dark),
                MaterialDesignColor(hex: 0x651fff, label: "A400", kind: .dark),
                MaterialDesignColor(hex: 0x6200ea, label: "A700", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Indigo",
            colors: [
                MaterialDesignColor(hex: 0xe8eaf6, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xc5cae9, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0x9fa8da, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0x7986cb, label:  "300", kind: .dark),
                MaterialDesignColor(hex: 0x5c6bc0, label:  "400", kind: .dark),
                MaterialDesignColor(hex: 0x3f51b5, label:  "500", kind: .dark),
                MaterialDesignColor(hex: 0x3949ab, label:  "600", kind: .dark),
                MaterialDesignColor(hex: 0x303f9f, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0x283593, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0x1a237e, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0x8c9eff, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0x536dfe, label: "A200", kind: .dark),
                MaterialDesignColor(hex: 0x3d5afe, label: "A400", kind: .dark),
                MaterialDesignColor(hex: 0x304ffe, label: "A700", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Blue",
            colors: [
                MaterialDesignColor(hex: 0xe3f2fd, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xbbdefb, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0x90caf9, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0x64b5f6, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0x42a5f5, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0x2196f3, label:  "500", kind: .dark),
                MaterialDesignColor(hex: 0x1e88e5, label:  "600", kind: .dark),
                MaterialDesignColor(hex: 0x1976d2, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0x1565c0, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0x0d47a1, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0x82b1ff, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0x448aff, label: "A200", kind: .dark),
                MaterialDesignColor(hex: 0x2979ff, label: "A400", kind: .dark),
                MaterialDesignColor(hex: 0x2962ff, label: "A700", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Light Blue",
            colors: [
                MaterialDesignColor(hex: 0xe1f5fe, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xb3e5fc, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0x81d4fa, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0x4fc3f7, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0x29b6f6, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0x03a9f4, label:  "500", kind: .light),
                MaterialDesignColor(hex: 0x039be5, label:  "600", kind: .dark),
                MaterialDesignColor(hex: 0x0288d1, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0x0277bd, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0x01579b, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0x80d8ff, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0x40c4ff, label: "A200", kind: .light),
                MaterialDesignColor(hex: 0x00b0ff, label: "A400", kind: .light),
                MaterialDesignColor(hex: 0x0091ea, label: "A700", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Cyan",
            colors: [
                MaterialDesignColor(hex: 0xe0f7fa, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xb2ebf2, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0x80deea, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0x4dd0e1, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0x26c6da, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0x00bcd4, label:  "500", kind: .light),
                MaterialDesignColor(hex: 0x00acc1, label:  "600", kind: .light),
                MaterialDesignColor(hex: 0x0097a7, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0x00838f, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0x006064, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0x84ffff, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0x18ffff, label: "A200", kind: .light),
                MaterialDesignColor(hex: 0x00e5ff, label: "A400", kind: .light),
                MaterialDesignColor(hex: 0x00b8d4, label: "A700", kind: .light)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Teal",
            colors: [
                MaterialDesignColor(hex: 0xe0f2f1, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xb2dfdb, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0x80cbc4, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0x4db6ac, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0x26a69a, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0x009688, label:  "500", kind: .dark),
                MaterialDesignColor(hex: 0x00897b, label:  "600", kind: .dark),
                MaterialDesignColor(hex: 0x00796b, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0x00695c, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0x004d40, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0xa7ffeb, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0x64ffda, label: "A200", kind: .light),
                MaterialDesignColor(hex: 0x1de9b6, label: "A400", kind: .light),
                MaterialDesignColor(hex: 0x00bfa5, label: "A700", kind: .light)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Green",
            colors: [
                MaterialDesignColor(hex: 0xe8f5e9, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xc8e6c9, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xa5d6a7, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0x81c784, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0x66bb6a, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0x4caf50, label:  "500", kind: .light),
                MaterialDesignColor(hex: 0x43a047, label:  "600", kind: .dark),
                MaterialDesignColor(hex: 0x388e3c, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0x2e7d32, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0x1b5e20, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0xb9f6ca, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0x69f0ae, label: "A200", kind: .light),
                MaterialDesignColor(hex: 0x00e676, label: "A400", kind: .light),
                MaterialDesignColor(hex: 0x00c853, label: "A700", kind: .light)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Light Green",
            colors: [
                MaterialDesignColor(hex: 0xf1f8e9, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xdcedc8, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xc5e1a5, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0xaed581, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0x9ccc65, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0x8bc34a, label:  "500", kind: .light),
                MaterialDesignColor(hex: 0x7cb342, label:  "600", kind: .light),
                MaterialDesignColor(hex: 0x689f38, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0x558b2f, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0x33691e, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0xccff90, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0xb2ff59, label: "A200", kind: .light),
                MaterialDesignColor(hex: 0x76ff03, label: "A400", kind: .light),
                MaterialDesignColor(hex: 0x64dd17, label: "A700", kind: .light)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Lime",
            colors: [
                MaterialDesignColor(hex: 0xf9fbe7, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xf0f4c3, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xe6ee9c, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0xdce775, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0xd4e157, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0xcddc39, label:  "500", kind: .light),
                MaterialDesignColor(hex: 0xc0ca33, label:  "600", kind: .light),
                MaterialDesignColor(hex: 0xafb42b, label:  "700", kind: .light),
                MaterialDesignColor(hex: 0x9e9d24, label:  "800", kind: .light),
                MaterialDesignColor(hex: 0x827717, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0xf4ff81, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0xeeff41, label: "A200", kind: .light),
                MaterialDesignColor(hex: 0xc6ff00, label: "A400", kind: .light),
                MaterialDesignColor(hex: 0xaeea00, label: "A700", kind: .light)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Yellow",
            colors: [
                MaterialDesignColor(hex: 0xfffde7, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xfff9c4, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xfff59d, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0xfff176, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0xffee58, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0xffeb3b, label:  "500", kind: .light),
                MaterialDesignColor(hex: 0xfdd835, label:  "600", kind: .light),
                MaterialDesignColor(hex: 0xfbc02d, label:  "700", kind: .light),
                MaterialDesignColor(hex: 0xf9a825, label:  "800", kind: .light),
                MaterialDesignColor(hex: 0xf57f17, label:  "900", kind: .light),
                MaterialDesignColor(hex: 0xffff8d, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0xffff00, label: "A200", kind: .light),
                MaterialDesignColor(hex: 0xffea00, label: "A400", kind: .light),
                MaterialDesignColor(hex: 0xffd600, label: "A700", kind: .light)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Amber",
            colors: [
                MaterialDesignColor(hex: 0xfff8e1, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xffecb3, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xffe082, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0xffd54f, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0xffca28, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0xffc107, label:  "500", kind: .light),
                MaterialDesignColor(hex: 0xffb300, label:  "600", kind: .light),
                MaterialDesignColor(hex: 0xffa000, label:  "700", kind: .light),
                MaterialDesignColor(hex: 0xff8f00, label:  "800", kind: .light),
                MaterialDesignColor(hex: 0xff6f00, label:  "900", kind: .light),
                MaterialDesignColor(hex: 0xffe57f, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0xffd740, label: "A200", kind: .light),
                MaterialDesignColor(hex: 0xffc400, label: "A400", kind: .light),
                MaterialDesignColor(hex: 0xffab00, label: "A700", kind: .light)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Orange",
            colors: [
                MaterialDesignColor(hex: 0xfff3e0, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xffe0b2, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xffcc80, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0xffb74d, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0xffa726, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0xff9800, label:  "500", kind: .light),
                MaterialDesignColor(hex: 0xfb8c00, label:  "600", kind: .light),
                MaterialDesignColor(hex: 0xf57c00, label:  "700", kind: .light),
                MaterialDesignColor(hex: 0xef6c00, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0xe65100, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0xffd180, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0xffab40, label: "A200", kind: .light),
                MaterialDesignColor(hex: 0xff9100, label: "A400", kind: .light),
                MaterialDesignColor(hex: 0xff6d00, label: "A700", kind: .light)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Deep Orange",
            colors: [
                MaterialDesignColor(hex: 0xfbe9e7, label:   "50", kind: .light),
                MaterialDesignColor(hex: 0xffccbc, label:  "100", kind: .light),
                MaterialDesignColor(hex: 0xffab91, label:  "200", kind: .light),
                MaterialDesignColor(hex: 0xff8a65, label:  "300", kind: .light),
                MaterialDesignColor(hex: 0xff7043, label:  "400", kind: .light),
                MaterialDesignColor(hex: 0xff5722, label:  "500", kind: .dark),
                MaterialDesignColor(hex: 0xf4511e, label:  "600", kind: .dark),
                MaterialDesignColor(hex: 0xe64a19, label:  "700", kind: .dark),
                MaterialDesignColor(hex: 0xd84315, label:  "800", kind: .dark),
                MaterialDesignColor(hex: 0xbf360c, label:  "900", kind: .dark),
                MaterialDesignColor(hex: 0xff9e80, label: "A100", kind: .light),
                MaterialDesignColor(hex: 0xff6e40, label: "A200", kind: .light),
                MaterialDesignColor(hex: 0xff3d00, label: "A400", kind: .dark),
                MaterialDesignColor(hex: 0xdd2c00, label: "A700", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Brown",
            colors: [
                MaterialDesignColor(hex: 0xefebe9, label:  "50", kind: .light),
                MaterialDesignColor(hex: 0xd7ccc8, label: "100", kind: .light),
                MaterialDesignColor(hex: 0xbcaaa4, label: "200", kind: .light),
                MaterialDesignColor(hex: 0xa1887f, label: "300", kind: .dark),
                MaterialDesignColor(hex: 0x8d6e63, label: "400", kind: .dark),
                MaterialDesignColor(hex: 0x795548, label: "500", kind: .dark),
                MaterialDesignColor(hex: 0x6d4c41, label: "600", kind: .dark),
                MaterialDesignColor(hex: 0x5d4037, label: "700", kind: .dark),
                MaterialDesignColor(hex: 0x4e342e, label: "800", kind: .dark),
                MaterialDesignColor(hex: 0x3e2723, label: "900", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Grey",
            colors: [
                MaterialDesignColor(hex: 0xfafafa, label:  "50", kind: .light),
                MaterialDesignColor(hex: 0xf5f5f5, label: "100", kind: .light),
                MaterialDesignColor(hex: 0xeeeeee, label: "200", kind: .light),
                MaterialDesignColor(hex: 0xe0e0e0, label: "300", kind: .light),
                MaterialDesignColor(hex: 0xbdbdbd, label: "400", kind: .light),
                MaterialDesignColor(hex: 0x9e9e9e, label: "500", kind: .light),
                MaterialDesignColor(hex: 0x757575, label: "600", kind: .dark),
                MaterialDesignColor(hex: 0x616161, label: "700", kind: .dark),
                MaterialDesignColor(hex: 0x424242, label: "800", kind: .dark),
                MaterialDesignColor(hex: 0x212121, label: "900", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Blue Grey",
            colors: [
                MaterialDesignColor(hex: 0xeceff1, label:  "50", kind: .light),
                MaterialDesignColor(hex: 0xcfd8dc, label: "100", kind: .light),
                MaterialDesignColor(hex: 0xb0bec5, label: "200", kind: .light),
                MaterialDesignColor(hex: 0x90a4ae, label: "300", kind: .light),
                MaterialDesignColor(hex: 0x78909c, label: "400", kind: .dark),
                MaterialDesignColor(hex: 0x607d8b, label: "500", kind: .dark),
                MaterialDesignColor(hex: 0x546e7a, label: "600", kind: .dark),
                MaterialDesignColor(hex: 0x455a64, label: "700", kind: .dark),
                MaterialDesignColor(hex: 0x37474f, label: "800", kind: .dark),
                MaterialDesignColor(hex: 0x263238, label: "900", kind: .dark)
            ]
        ),
        MaterialDesignColorGroup(
            name: "Black",
            colors: [
                MaterialDesignColor(hex: 0x000000, label: "Black", kind: .dark),
                MaterialDesignColor(hex: 0xffffff, label: "White", kind: .light)
            ]
        )
    ]
}

extension MaterialDesignPalette {
    static func colorGroup(for arbitraryColor: NSColor) -> MaterialDesignColorGroup? {
        guard let srgbColor = arbitraryColor.usingColorSpace(.sRGB) else {
            return nil
        }

        for colorGroup in MaterialDesignPalette.colorGroups {
            if colorGroup.colors.first(where: {$0.hex == srgbColor.hex}) != nil {
                return colorGroup
            }
        }
        return nil
    }
}
