/*:
## Material Design Color Picker Playground

Use this playground in combination with the `MaterialDesignColorPickerFramework` target for rapid iterative experimentation during development.
 
This approach reduces the tedium of reinstalling the color picker bundle and closing + reopening the host application after each build.

Choose "Editor" > "Live View" to see a live preview.
*/
import Cocoa
import PlaygroundSupport

@testable import MaterialDesignColorPickerFramework

let bundle = Bundle(identifier: "com.codecatalyst.MaterialDesignColorPickerFramework")!
bundle.load()

let colorPicker = MaterialDesignColorPicker()
let view = colorPicker.provideNewView(true)

colorPicker.viewSizeChanged(nil)

colorPicker.setColor(NSColor(hex: 0x000000)!)

PlaygroundPage.current.liveView = view
