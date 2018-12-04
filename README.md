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

### 1) Add HomeKit Usage Description to `Info.plist`

Open your project's `Info.plist` file, and add the `Privacy - HomeKit Usage Description` key.

Its value should be a `String` which is the message that should be shown to the user, when they asked to for HomeKit permissions.

### 2) Create a `LightingKit` object

Import the LightingKit library into the file you'd like to use it in:

`import LightingKit`

Most of your interactions with LightingKit with be through the `LightingKit` class.

Create a `LightingKit` object using the standard initializer:

`let kit = LightingKit()`

### 3) Connect to HomeKit

Execute your `LightingKit` object's `start()` function to connect to HomeKit:

`kit.start()`

**Important!** - Starting `LightingKit` using the `start()` function, will prompt the user for HomeKit permissions (if permission has not already been given).

### 4) Get a callback when LightingKit is ready

Starting LightingKit isn't much use if you don't check to see what happened!

Have your class conform to the `LightingKitPermissionsDelegate` protocol in order to receive a callback when `LightingKit` is ready:

```
extension ViewController: LightingKitPermissionsDelegate {
    func lightingKit(_ lightingKit: LightingKit, permissionsGranted: Bool) {
        if permissionsGranted {
            // Ready! Now you can control lights!
        } else {
            // Oops! The user didn't grant permission.
        }
    }
}
```

## Adding Homes, Rooms and Lights

In LightingKit, a user has Homes, Rooms and Lights.

### Homes

A `Home` is pretty self explanatory! It represents a particular home, which contains rooms and lights.

You can access an array of the user's homes via your `LightingKit` object:

`let usersHomes = kit.homes`

You can add a new `Home` like this:

```
kit.addHome(name: "29 Neibolt Street") { (home) in
    if let newHome = home {
        // The Home was added successfully!
    }
}
```

### Rooms

A `Room` belongs to a `Home`.

You can get an array of the rooms within a particular home, by passing a `Home` object as an argument to your `LightingKit` object's `rooms(forHome:)` method:

```
let rooms = kit.rooms(forHome: aHome)
```

A `Home` can contain an unlimited number of custom rooms. You can add a `Room` to a `Home` like this:

```
kit.addRoom(name: "Bedroom", toHome: myHome) { (room) in
    if let newRoom = room {
        // The Room was added successfully!
    }
}
```
### The "Default Room"

Every `Home` contains a default `Room`.

If the user has chosen not to add any custom rooms to their `Home`, then the `Home` will still contain one `Room`: the default room.

### Lights

A `Light` belongs to a `Room`.

You can get an array all of the lights within a particular room like this:

`let lights = kit.lights(forRoom: aRoom)`

