/*: 
 
# Material Design Color Picker Playground

Use this playground in combination with the `MaterialDesignColorPickerFramework` target for rapid interative experimentation during development.
 
This approach reduces the tedium of reinstalling the color picker bundle and closing + reopening the host application after each build.

Choose "View" | "Assistant Editor" | "Show Assistant Editor" in Xcode.
 */
import Cocoa
import PlaygroundSupport

@testable import MaterialDesignColorPickerFramework

let bundle = Bundle(identifier: "com.codecatalyst.MaterialDesignColorPickerFramework")!
bundle.load()

let colorPicker = MaterialDesignColorPicker()
let view = colorPicker.provideNewView(true)

PlaygroundPage.current.liveView = view
