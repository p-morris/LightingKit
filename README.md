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

## Controlling a `Light`

### Turning a light on and off

With a particular `Light` object in hand, you turn it on and off, via its `power` property:

```
light.power?.on(true, completion: { (error) in
    if error != nil {
        // Light on!
    }
})

```
You can check to see if a `Light` is currently powered on as well. The `Power` property is optional, so it must be unwrapped first:

```
if let power = light.power, power.isOn {
    // The light is turned on!
}
```

### Setting the brightness

Each `Light` also has a `brightness` property, which can be used to access the current brightness of the `Light`.

The brightness is an `Int` betweeen `0` and `100` (`100` being the highest possible brightness level):

`let brightnessLevel = light.brightness?.value`

You can set the brightness level like this:

```
light.brightness?.set(brightness: 50, completion: { (error) in
    if error == nil {
        // The brightness was set!
    }
})
```
### Fading the brighness over time

You can also update the brightness value of a `Light` over a set duration.

When you do this, the light's brightness will be gradually faded from its current value, to the value that you specify.

For example, to set the light's brightness to `100` over 30 seconds:

`light.brightness?.set(brightness: 100, duration: 30, brightnessDelegate: self)`

To receive updates about the status of such a brightness update, have your class conform to the `TimedBrightnessUpdateDelegate` protocol:

```
extension ViewController: TimedBrightnessUpdateDelegate {
    func brightness(_ brightness: Brightness, valueDidChange newValue: Int) {
        // The brightness was updated to a new value!
    }
    
    func brightness(_ brightness: Brightness, didCompleteTimedUpdate newValue: Int) {
        // The timed brightness update is complete!
    }
    
    func brightness(_ brightness: Brightness, timedUpdateFailed error: Error?) {
        // The timed brightness update failed
    }
}
```
## Setting up new lights

If a light has never been added to HomeKit, then you will have to add it before you can control it.

Adding a `Light` to HomeKit involves two simple steps: searching for new lights, and then adding them to a room.

### 1) Searching for lights to set up

Simple set the `searchDelegate` property of your `LightingKit` object, and then start the search:

```
kit.searchDelegate = self
kit.searchForNewLighting()
```
You'll need to have your class conform to the `LightingKitAccessorySearchDelegate` protocol, in order to receive callbacks when a lighting-related accessory is found:

```
extension ViewController: LightingKitAccessorySearchDelegate {
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light) {
        // LightingKit found a new light!
    }
    func lightingKit(_ lightingKit: LightingKit, foundNewBridge bridge: Bridge) {
        // Don't worry, I'll explain what a bridge is later!
    }
}
```
### 2) Adding a new light to a room

Once you've found a `Light` that needs setting up, you simply  add it to a room in order to start the set up process:

```
kit.add(newLight: light, toRoom: room) { (success) in
    if success {
        // The light was setup, and added to the room!
    }
}
```
**Important!** - Adding a new light to a room will trigger the iOS HomeKit accessory setup process within your app.

Once a new `Light` has success been added to a `Room`, you can control it as usual!

## Bridges and bridged lights

Some smartlights require a "bridge" in order to connect to a network. Philip's Hue lighting, for example, requires such a bridge.

The bridge *itself* is a hardware accessory that needs to be added to HomeKit.

Once a bridge is added, all of the accessories that are connected *to* that bridge are **automatically** added to HomeKit for the user.

### Setting up a new `Bridge`

When you conduct a new lighting search with LightingKit, your `LightingKitAccessorySearchDelegate` will receive a callback when a new bridge is discovered requiring setup:

```
extension AppDelegate: LightingKitAccessorySearchDelegate {
    func lightingKit(_ lightingKit: LightingKit, foundNewBridge bridge: Bridge) {
        // A new bridge was found
    }
}
```
With a new `Bridge` object in hand, you can set it up like this:
```
kit.add(newBridge: bridge, toRoom: room) { (success, lights) in
    if success {
        // The bridge was set up successfully!
    }
}
```
On `completion`, the `success` boolean will indicate if the setup was successful.

If `LightingKit` found any lighting accessories connected to the bridge, they will be passed in the completion.

In the above example, `lights` is an optional array of `Light` objects (and will be set to `nil` if no lights were connected to the bridge).

**Important!** - After a `Bridge` is set up, any lights that are connected to it are automatically added to the "Default room" of the 