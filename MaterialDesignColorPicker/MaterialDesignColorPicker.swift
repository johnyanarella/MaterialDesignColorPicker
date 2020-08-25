//
//  MaterialDesignColorPicker.swift
//  MaterialDesignColorPicker
//
//  Created by John Yanarella on 1/7/17.
//  Copyright © 2017-2020 John Yanarella.
//

import Cocoa

func log(_ message: String) {
    NSLog("MaterialDesignColorPicker - \(message)")
}

public final class MaterialDesignColorPicker: NSColorPicker {
    private static let backgroundColor = NSColor.windowBackgroundColor

    fileprivate static let swatchCollectionViewHeaderIdentifier = NSUserInterfaceItemIdentifier(rawValue: "MaterialDesignColorSwatchCollectionViewHeaderView")
    fileprivate static let swatchCollectionViewItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "MaterialDesignColorSwatchCollectionViewItem")

    @IBOutlet fileprivate var view: NSView! {
        didSet {
            view.wantsLayer = true
            view.layer?.backgroundColor = MaterialDesignColorPicker.backgroundColor.cgColor
        }
    }

    @IBOutlet fileprivate weak var paletteView: MaterialDesignColorPaletteView! {
        didSet {
            paletteView.delegate = self
            paletteView.selectedColorGroup = selectedColorGroup
        }
    }

    @IBOutlet fileprivate weak var scrollView: NSScrollView! {
        didSet {
            scrollView.wantsLayer = true
            scrollView.layer?.backgroundColor = MaterialDesignColorPicker.backgroundColor.cgColor
        }
    }

    @IBOutlet fileprivate weak var swatchCollectionView: NSCollectionView! {
        didSet {
            swatchCollectionView.wantsLayer = true
            swatchCollectionView.layer?.backgroundColor = MaterialDesignColorPicker.backgroundColor.cgColor

            swatchCollectionView.backgroundColors = [MaterialDesignColorPicker.backgroundColor]

            swatchCollectionView.delegate = self
            swatchCollectionView.dataSource = self

            let headerNib = NSNib(nibNamed: "MaterialDesignColorSwatchCollectionViewHeaderView", bundle: bundle)
            swatchCollectionView.register(headerNib, forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, withIdentifier: MaterialDesignColorPicker.swatchCollectionViewHeaderIdentifier)

            let itemNib = NSNib(nibNamed: "MaterialDesignColorSwatchCollectionViewItem", bundle: bundle)
            swatchCollectionView.register(itemNib, forItemWithIdentifier: MaterialDesignColorPicker.swatchCollectionViewItemIdentifier)
        }
    }

    fileprivate let bundle = Bundle(for: MaterialDesignColorPicker.self)

    fileprivate var selectedColorGroup: MaterialDesignColorGroup = MaterialDesignPalette.colorGroups[0]

    fileprivate var loadedColorGroup: MaterialDesignColorGroup = MaterialDesignPalette.colorGroups[0]

    fileprivate var selectedColor: MaterialDesignColor?

    fileprivate var initialColorSet: Bool = false

    fileprivate var initialSizeSet: Bool = false

    public override init() {
        super.init()
    }

    public required init?(pickerMask mask: Int, colorPanel owningColorPanel: NSColorPanel) {
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        let hostAppKitVersion = NSVersionOfLinkTimeLibrary("AppKit") >> 16
        log("Version: \(version) - Host App Linked SDK: \(hostAppKitVersion)")

        super.init(pickerMask: mask, colorPanel: owningColorPanel)
    }

    public override var provideNewButtonImage: NSImage {
        let icon = bundle.image(forResource: "ButtonImage")!
        return icon
    }

    public override var buttonToolTip: String {
        return NSLocalizedString("Material Design", comment: "Tooltip for the Material Design color picker button in the color panel")
    }

    public override func viewSizeChanged(_ sender: Any?) {
        super.viewSizeChanged(sender)

        if swatchCollectionView != nil {
            if !initialSizeSet {
                DispatchQueue.main.async {
                    self.swatchCollectionView.reloadData()
                }
                initialSizeSet = true
            } else {
                swatchCollectionView.collectionViewLayout?.invalidateLayout()
            }
        }
    }

    public override var minContentSize: NSSize {
        return NSSize(width: 280, height: 448)
    }

    fileprivate func loadFonts() {
        let paths = bundle.paths(forResourcesOfType: "ttf", inDirectory: "Fonts")
        for path in paths {
            let url = NSURL(fileURLWithPath: path as String)

            var errorRef: Unmanaged<CFError>?
            CTFontManagerRegisterFontsForURL(url, .process, &errorRef)
        }
    }

    fileprivate func loadView() {
        guard bundle.loadNibNamed("MaterialDesignColorPicker", owner: self, topLevelObjects: nil) else {
            fatalError()
        }
    }

    fileprivate func load(colorGroup: MaterialDesignColorGroup) {
        loadedColorGroup = colorGroup
        swatchCollectionView.reloadData()
        updateSelection()
    }

    fileprivate func select(colorGroup: MaterialDesignColorGroup, at locationInWindow: NSPoint, animated: Bool) {
        if selectedColorGroup != colorGroup {
            selectedColorGroup = colorGroup
            paletteView.selectedColorGroup = colorGroup

            if animated {
                let rippleColor = colorGroup.primaryColor.color
                let startingPoint = scrollView.convert(locationInWindow, from: nil)
                scrollView.ripple(color: rippleColor, from: startingPoint, transition: {
                    self.load(colorGroup: colorGroup)
                })
            } else {
                load(colorGroup: colorGroup)
            }
        }
    }

    fileprivate func select(color: MaterialDesignColor?) {
        selectedColor = color
        updateSelection()
    }

    fileprivate func apply(color: MaterialDesignColor) {
        let transparentColor = color.color.withAlphaComponent(colorPanel.alpha)
        log("Applying color: \(transparentColor.debugDescription)")
        colorPanel.color = transparentColor
    }

    fileprivate func updateSelection() {
        swatchCollectionView.deselectItems(at: swatchCollectionView.selectionIndexPaths)
        if let selectedColor = selectedColor, let itemIndex = loadedColorGroup.colors.firstIndex(of: selectedColor) {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            swatchCollectionView.selectItems(at: [indexPath], scrollPosition: .nearestHorizontalEdge)
        }
    }
}

// MARK: - NSColorPickingCustom
extension MaterialDesignColorPicker: NSColorPickingCustom {
    public func supportsMode(_ mode: NSColorPanel.Mode) -> Bool {
        return (mode == .RGB)
    }

    public func currentMode() -> NSColorPanel.Mode {
        return .RGB
    }

    public func provideNewView(_ initialRequest: Bool) -> NSView {
        if initialRequest {
            loadFonts()
            loadView()
        }
        return view
    }

    public func setColor(_ newColor: NSColor) {
        log("Received color: \(newColor.debugDescription)")
        let opaqueColor = newColor.withAlphaComponent(1.0)
        if let colorGroup = MaterialDesignPalette.colorGroup(for: opaqueColor) {
            let startingLocation = colorPanel.showsAlpha ? NSPoint(x: 24.0, y: 76.0) : NSPoint(x: 24.0, y: 24.0)
            select(colorGroup: colorGroup, at: startingLocation, animated: initialColorSet)
            select(color: colorGroup.color(for: opaqueColor))
        } else {
            select(color: selectedColor)
        }
        initialColorSet = true
    }
}

// MARK: - MaterialDesignColorPaletteViewDelegate
extension MaterialDesignColorPicker: MaterialDesignColorPaletteViewDelegate {
    func didSelect(_ colorPaletteView: MaterialDesignColorPaletteView, colorGroup: MaterialDesignColorGroup, at locationInWindow: NSPoint) {
        select(colorGroup: colorGroup, at: locationInWindow, animated: true)
        select(color: colorGroup.primaryColor)
        apply(color: colorGroup.primaryColor)
    }
}

// MARK: - NSCollectionViewDelegate
extension MaterialDesignColorPicker: NSCollectionViewDelegate {
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {
            return
        }

        let color = loadedColorGroup.colors[indexPath.item]
        select(color: color)
        apply(color: color)
    }
}

// MARK: - NSCollectionViewDelegateFlowLayout
extension MaterialDesignColorPicker: NSCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 32.0)
    }

    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return loadedColorGroup.colors.count >= 10 ? NSSize(width: collectionView.bounds.width, height: 72.0) : .zero
    }
}

// MARK: - NSCollectionViewDataSource
extension MaterialDesignColorPicker: NSCollectionViewDataSource {
    public func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadedColorGroup.colors.count
    }

    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: MaterialDesignColorPicker.swatchCollectionViewItemIdentifier, for: indexPath as IndexPath)

        guard let collectionViewItem = item as? MaterialDesignColorSwatchCollectionViewItem else {
            return item
        }

        let color = loadedColorGroup.colors[indexPath.item]
        collectionViewItem.color = color

        return item
    }

    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        let view = swatchCollectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: MaterialDesignColorPicker.swatchCollectionViewHeaderIdentifier, for: indexPath)

        guard let collectionViewSection = view as? MaterialDesignColorSwatchCollectionViewHeaderView else {
            return view
        }

        collectionViewSection.colorGroup = loadedColorGroup

        return view
    }
}
