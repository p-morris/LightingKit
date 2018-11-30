//
//  LightingKit.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

public protocol LightingKitPermissionsDelegate: class {
    /**
     Executed when LightingKit has finished configuring.
     - Parameters:
     - lightingKit: The `LightingKit` object that was configured.
     - permissionsGranted: Indicates whether HomeKit permissions have been granted or not.
     */
    func lightingKit(_ lightingKit: LightingKit, permissionsGranted: Bool)
}

public protocol LightingKitAccessorySearchDelegate: class {
    /**
     Executed when LightingKit has found a new `Light` that hasn't been set up with HomeKit.
     - Parameters:
     - lightingKit: The `LightingKit` object that found the `Light`.
     - light: The `Light` that was found.
     */
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light)
    /**
     Executed when LightingKit has found a new `Bridge` that hasn't been set up with HomeKit.
     - Parameters:
     - lightingKit: The `LightingKit` object that found the `Light`.
     - bridge: The `Bridge` that was found.
     */
    func lightingKit(_ lightingKit: LightingKit, foundNewBridge bridge: Bridge)
}

/// Used to access Homes, Rooms and Lights via HomeKit
public final class LightingKit: NSObject {
    /// The object that acts as the delegate
    public weak var searchDelegate: LightingKitAccessorySearchDelegate?
    /// The object that acts as the permissions delegate
    public weak var permissionsDelegate: LightingKitPermissionsDelegate?
    /// The `HMHomeManager` object to use.
    private var homeManager: HomeManagerProtocol?
    /// The `HomeKitPermission` to use for requesting HomeKit permissions.
    private var permission: HomeKitPermission?
    /// The `LightingBrowser` object to use for finding new lights.
    private let browser: LightingKitBrowser
    /// Indicates whether LightingKit is ready to use.
    public var ready: Bool {
        return (homeManager?.permissionGranted ?? false)
    }
    public convenience override init() {
        self.init(browser: LightingBrowser())
    }
    init(browser: LightingKitBrowser = LightingBrowser()) {
        self.browser = browser
    }
    /**
     Configures the `LightingKit` object with HomeKit.
     - Warning: If this is the first time you have executed `configure` the HomeKit
     permissions alert will be shown to the user. The delegate callback `lightingKit(_:permissionsGranted:)`
     will be executed when confirguration is complete.
     */
    public func start() {
        guard !ready else {
            permissionsDelegate?.lightingKit(self, permissionsGranted: ready)
            return
        }
        configure()
    }
    /**
     Configures the object via HomeKit.
     - Parameters:
     - permission: The `HomeKitPermission` to use for requesting HomeKit permissions.
     - manager: The `HMHomeManager` to use for access to HomeKit devices.
     */
    internal func configure(permission: HomeKitPermission = LightingKitPermission(),
                            manager: HomeManagerProtocol = HMHomeManager()) {
        self.permission = permission
        permission.requestPermission(homeManager: manager) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.homeManager = manager
                self.homeManager?.delegate = self
            }
            self.permissionsDelegate?.lightingKit(self, permissionsGranted: success)
        }
    }
}

// MARK: - Homes
extension LightingKit {
    /// An array of `Home` objects currently available for use.
    /// Empty if non are available (including when LightningKit is not ready)
    public var homes: [Home] {
        return homeManager?.homes.lightingKitObjects() ?? []
    }
    /**
     Attempts to add a new home to HomeKit.
     - Parameters:
     - name: The name of the new home.
     - completion: The closure to execute on completion. The new `Home` is passed as a parameter
     if successful, `nil` if not.
     */
    public func addHome(name: String, completion: @escaping (Home?) -> Void) {
        homeManager?.addHome(withName: name) { home, _ in
            completion(home?.lightingKitObject())
        }
    }
}

// MARK: - Rooms
extension LightingKit {
    /**
     Returns the currently available Rooms.
     - Parameters:
     - home: The `Home` that the `Room` objects returned should be associated with.
     - Returns: An array of `Room` objects, all of which belong to `home`.
     - Note: Returns and empty array if there are no rooms, or if `LightingKit` is not ready.
     */
    public func rooms(forHome home: Home) -> [Room] {
        return homeManager?.homes.rooms(for: home) ?? []
    }
    /**
     Attempts to add a new room to a home.
     - Parameters:
     - name: The name of the new room.
     - home: The `Home` to add the new room to.
     - completion: The closure to execute on completion. The new `Room` is passed as a parameter
     if successful, `nil` if not.
     */
    public func addRoom(name: String, toHome home: Home, completion: @escaping (Room?) -> Void) {
        guard let home = homeManager?.homes.filter({ home == $0 }).first else {
            completion(nil)
            return
        }
        home.addRoom(withName: name) { room, _ in
            completion(room?.lightingKitObject())
        }
    }
    /**
     Attempts to add a new light (that has yet to be set up) to the specified room.
     - Parameters:
     - light: The `Light` to add.
     - room: The `Room` to add `light` to.
     - completion: The closure to execute on completion. If successful, `true` will be passed in
     otherwise `false`.
     */
    public func add(newLight light: Light, toRoom room: Room, completion: @escaping (Bool) -> Void) {
        guard let home = homeManager?.homes.home(for: room),
            let room = home.rooms.filter({ room == $0 }).first,
            let accessory = browser.newAccessories.filter({ light == $0 }).first else {
            completion(false)
            return
        }
        home.addAccessory(accessory) { _ in
            home.assignAccessory(accessory, to: room, completionHandler: { error in
                // FIXME: OCP - Should be extendable without modification. If I want to add hue support,
                // I need to amend the class.
                light.brightness = Brightness(
                    homeKitCharacteristic: accessory.services.light?.characteristics.brightness
                )
                light.power = Power(homeKitCharacteristic: accessory.services.light?.characteristics.power)
                completion(error == nil)
            })
        }
    }
    /**
     Attempts to add a new bridge (that has yet to be set up) to the `Home` associated with the specified room.
     - Parameters:
     - bridge: The `Bridge` to add..
     - room: The `Room` whose `Home` that `bridge` should be added to.
     - completion: The closure to execute on completion. If successful, `true` will be passed otherwise `false`.
      If `bridge` contains any bridged lighting an array of `Light` objects will also be passed, otherwise `nil`.
     */
    public func add(newBridge bridge: Bridge, toRoom room: Room, completion: @escaping (Bool, [Light]?) -> Void) {
        guard let home = homeManager?.homes.home(for: room),
            let accessory = browser.newAccessories.filter({ bridge == $0 }).first else {
                completion(false, nil)
                return
        }
        home.addAccessory(accessory) { error in
            completion(
                error == nil,
                self.homeManager?.homes.lightingKitLights(for: bridge)
            )
        }
    }
}

// MARK: - Lights
extension LightingKit {
    /**
     Begins searching for new lights.
     */
    public func searchForNewLighting() {
        findNewLights()
    }
    /**
     Stops searching for new lights.
     */
    public func stopNewLightingSearch() {
        browser.stop()
    }
    /**
     Begins searching for new lights, and notifies the `delegate` when one is found.
     - Parameters:
     - browser: The `LightingBrowser` to use for the search.
     */
    internal func findNewLights() {
        browser.findNewLights { [weak self] accessory in
            guard let self = self else { return }
            if accessory.category.isBridge {
                self.searchDelegate?.lightingKit(self, foundNewBridge: accessory.lightingKitObject())
            } else {
                self.searchDelegate?.lightingKit(self, foundNewLight: accessory.lightingKitObject())
            }
        }
    }
    /**
     Returns the currently available Lights for a given home.
     - Parameters:
     - home: The `Home` the `Light` objects returned should be associated with.
     - Returns: An array of `Light` objects, all of which belong to `home`.
     - Note: Returns and empty array if there are no lights, or if `LightingKit` is not ready.
     */
    public func lights(forHome home: Home) -> [Light] {
        return homeManager?.homes.lightingKitLights(for: home) ?? []
    }
    /**
     Returns the currently available Lights for a given room.
     - Parameters:
     - room: The `Room` the `Light` objects returned should be associated with.
     - Returns: An array of `Light` objects, all of which belong to `room`.
     - Note: Returns and empty array if there are no lights, or if `LightingKit` is not ready.
     */
    public func lights(forRoom room: Room) -> [Light] {
        return homeManager?.homes.lightingKitLights(for: room) ?? []
    }
    /**
     Returns the currently available Lights for a given bridge.
     - Parameters:
     - bridge: The `Bridge` the `Light` objects returned should be associated with.
     - Returns: An array of `Light` objects, all of which belong to `bridge`.
     - Note: Returns and empty array if there are no lights, or if `LightingKit` is not ready.
     */
    public func lights(forBridge bridge: Bridge) -> [Light] {
        return homeManager?.homes.lightingKitLights(for: bridge) ?? []
    }
}

// MARK: - homeManager delegate
extension LightingKit: HMHomeManagerDelegate {

}
