//
//  LightingKit.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Used to access Homes, Rooms and Lights via HomeKit
public final class LightingKit: NSObject {
    /// The `HMHomeManager` object to use.
    private var homeManager: HomeManagerProtocol?
    /// The `HomeKitPermission` to use for requesting HomeKit permissions.
    private var permission: HomeKitPermission?
    /// Indicates whether LightingKit is ready to use.
    public var ready: Bool {
        return homeManager != nil
    }
    /// An array of `Home` objects currently available for use.
    /// Empty if non are available (including when LightningKit is not ready)
    public var homes: [Home] {
        return homeManager?.homes.lightingKitObjects() ?? []
    }
    /**
     Initializes a new `LightingKit` object.
     - Returns: An initialized `LightingKit` object.
     - Warning: Initializing an instance of LightingKit will display the HomeKit permissions alert,
     in the event that permissions have not already been granted.
     */
    public override init() {
        super.init()
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
        // Note: requestPermission retains a reference to this closure. Reference to
        // self *must* be unowned.
        permission.requestPermission(homeManager: manager) { [unowned self] success in
            if success {
                self.homeManager = manager
                self.homeManager?.delegate = self
            } else {
                self.homeManager = nil
                self.homeManager?.delegate = nil
            }
        }
    }
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
     Returns the currently available Lights.
     - Parameters:
     - home: The `Room` the `Light` objects returned should be associated with.
     - Returns: An array of `Light` objects, all of which belong to `room`.
     - Note: Returns and empty array if there are no lights, or if `LightingKit` is not ready.
     */
    public func lights(forRoom room: Room) -> [Light] {
        return homeManager?.homes.lightingKitLights(for: room) ?? []
    }
}

extension LightingKit: HMHomeManagerDelegate {

}
