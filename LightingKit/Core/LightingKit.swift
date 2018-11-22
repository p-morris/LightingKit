//
//  LightingKit.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

protocol LightingKitDelegate: class {
    func lightingKit(_ lightingKit: LightingKit, permissionsGranted: Bool)
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light)
}

/// Used to access Homes, Rooms and Lights via HomeKit
public final class LightingKit: NSObject {
    /// The object that acts as the delegate
    weak var delegate: LightingKitDelegate?
    /// The `HMHomeManager` object to use.
    private var homeManager: HomeManagerProtocol? {
        didSet {
            delegate?.lightingKit(self, permissionsGranted: ready)
        }
    }
    /// The `HomeKitPermission` to use for requesting HomeKit permissions.
    private var permission: HomeKitPermission?
    /// The `LightingBrowser` object to use for finding new lights.
    private var browser: LightingBrowser?
    /// Indicates whether LightingKit is ready to use.
    public var ready: Bool {
        return homeManager != nil && (homeManager?.permissionGranted ?? false)
    }
    /**
     Configures the `LightingKit` object with HomeKit.
     - Warning: If this is the first time you have executed `configure` the HomeKit
     permissions alert will be shown to the user. The delegate callback `lightingKit(_:permissionsGranted:)`
     will be executed when confirguration is complete.
     */
    public func configureHomeKit() {
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
            if success {
                self?.homeManager = manager
                self?.homeManager?.delegate = self
            } else {
                self?.homeManager = nil
                self?.homeManager?.delegate = nil
            }
        }
    }
}

//MARK:- Homes
extension LightingKit {
    /// An array of `Home` objects currently available for use.
    /// Empty if non are available (including when LightningKit is not ready)
    public var homes: [Home] {
        return homeManager?.homes.lightingKitObjects() ?? []
    }
}

//MARK:- Rooms
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
}

//MARK:- Lights
extension LightingKit {
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
     Begins searching for new lights.
     */
    public func searchForNewLighting() {
        findNewLights()
    }
    /**
     Stops searching for new lights.
     */
    public func stopNewLightingSearch() {
        browser?.stop()
        browser = nil
    }
    /**
     Begins searching for new lights, and notifies the `delegate` when one is found.
     - Parameters:
     - browser: The `LightingBrowser` to use for the search.
     */
    private func findNewLights(browser: LightingBrowser = LightingBrowser()) {
        self.browser = browser
        browser.findNewLights { [unowned self] accessory in
            self.delegate?.lightingKit(self, foundNewLight: accessory.lightingKitObject())
        }
    }
}

//MARK:- homeManager delegate
extension LightingKit: HMHomeManagerDelegate {

}
