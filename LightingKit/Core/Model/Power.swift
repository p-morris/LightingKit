//
//  Power.swift
//  LightingKit
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Used to change the power state of a `Light` to on  or off.
public final class Power: Characteristic {
    /// The current on/off state.
    public var on: Bool {
        return homeKitCharacteristic.value as? Bool ?? false
    }
    /// The power characteristic of the light
    internal let homeKitCharacteristic: HomeKitCharacteristicProtocol
    /**
     Initializes a `Power` object.
     - Parameters:
     - characteristic: The `HMCharacteristic` that represents the light's power state.
     - returns: An initialized `Power` object.
     */
    internal init?(homeKitCharacteristic: HomeKitCharacteristicProtocol) {
        guard homeKitCharacteristic.type == .power else {
            return nil
        }
        self.homeKitCharacteristic = homeKitCharacteristic
    }
    /**
     Used to turn the power of the `Light` on or off.
     - Parameters:
     - on: A `Bool` representing whether the `Light` should be turned on (`true`) or off (`false`).
     - completion: The closure to execute when the power value has been updated.
     */
    public func on(_ on: Bool, completion: @escaping (Error?) -> Void) {
        homeKitCharacteristic.writeValue(on, completionHandler: completion)
    }
}
