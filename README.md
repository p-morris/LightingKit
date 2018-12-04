# LightingKit
## A simple library, for discovering and controlling HomeKit Lights on iOS.
### Introduction
LightingKit is a simple iOS library for discovering and using lighting accessories via HomeKit. It is specifically designed for dealing with lightbulb accessories.

With LightingKit, you can:

- Discover new lights and add them to a home and room.
- Turn lights on and off.
- Set the brightness.
- Change the brightness progressively over a specified duration.
- Support for hue and saturation will be added soon.

## Installing LightingKit

### Carthage

Add LightingKit as a dependency in your project's `Cartfile`:

`github "p-morris/LightingKit" ~> 1.0.0`

Update your project's dependencies using Carthage:

`carthage update`

Make sure that `LightingKit.framework` is linked in your project's build settings, and that it is copied as a resource in your project's build phases.

Add the `HomeKit` iOS framework to your project.

### Cocoapods

Add LightingKit to your Podfile:

`pod 'LightingKit'`

Install LightingKit by running:

`pod install`

## Getting started

### Add HomeKit Usage Description to `Info.plist`

Open your project's `Info.plist` file, and add the `Privacy - HomeKit Usage Description` key.

Its value should be a `String` which is the message that should be shown to the user of your app when they asked to grant your app HomeKit permissions.

### Create a `LightingKit` object

Import the LightingKit library into the file you'd like to use it in:

`import LightingKit`

Most of your interactions with LightingKit with be through the `LightingKit` class.

Create a `LightingKit` object using the standard initializer:

`let kit = LightingKit()`

### Connect to HomeKit

Execute your `LightingKit` object's `start()` function to connect to HomeKit:

`kit.start()`

**Important!** - Starting `LightingKit` using the `start()` function, will prompt the user for HomeKit permissions (if permission has not already been given).

### LightingKitPermissionsDelegate

Starting LightingKit isn't much use if you don't check to see what happened!

Make your class conform to the `LightingKitPermissionsDelegate` protocol in order to receive a callback when `LightingKit` is ready:

```
extension ViewController: LightingKitPermissionsDelegate {
    func lightingKit(_ lightingKit: LightingKit, permissionsGranted: Bool) {
        if permissionsGranted {
            // Control lights!
        } else {
            // The user didn't grant permission.
        }
    }
}