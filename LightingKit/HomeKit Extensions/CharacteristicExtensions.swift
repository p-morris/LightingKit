//
//  CharacteristicExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Represents a HomeKit Characteristic type
enum CharacteristicType {
    case power
    case brightness
    case unknown
}

/// An abstraction for HomeKit Characteristics
protocol HomeKitCharacteristicProtocol {
    var characteristicType: String { get }
    var value: Any? { get }
    func writeValue(_ value: Any?, completionHandler completion: @escaping (Error?) -> Void)
}

/// Used to map `HMCharacteristicType` to `CharacteristicType`
extension HomeKitCharacteristicProtocol {
    /// The type of the characteristic.
    var type: CharacteristicType {
        switch characteristicType {
        case HMCharacteristicTypePowerState: return .power
        case HMCharacteristicTypeBrightness: return .brightness
        default: return .unknown
        }
    }
}

extension HMCharacteristic: HomeKitCharacteristicProtocol { }
