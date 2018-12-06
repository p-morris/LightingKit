//
//  CharacteristicArrayExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 05/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Used to add computed properties to support easy access to brightness and power characteristics
internal extension Array where Element: HomeKitCharacteristicProtocol {
    /// The brightness characteristic if one exists, `nil` otherwise.
    var brightness: Element? {
        return filter { $0.characteristicType == HMCharacteristicTypeBrightness }.first
    }
    /// The power characteristic if one exists, `nil` otherwise.
    var power: Element? {
        return filter { $0.characteristicType == HMCharacteristicTypePowerState }.first
    }
    /**
     Returns an array `Characteristic` objects.
     - Returns: An array of `Characteristic` objects.
     */
    func lightingKitCharacteristics<T>() -> [T] where T: Characteristic {
        var characteristics: [T] = []
        forEach {
            if let characteristic = T.init(homeKitCharacteristic: $0) {
                characteristics.append(characteristic)
            }
        }
        return characteristics
    }
}
