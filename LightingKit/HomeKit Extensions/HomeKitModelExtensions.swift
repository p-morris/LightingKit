//
//  HomeKitModelExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// An abstraction for HomeKit objects
internal protocol HomeKitObjectProtocol {
    var name: String { get }
    var uniqueIdentifier: UUID { get }
}

/// Used to bridge HomeKit objects to LightningKit structs
extension HomeKitObjectProtocol {
    /**
     Returns a `LightingKitObject` representing the current HomeKit object.
     - Parameters:
     - Returns: An initialized instance of a concrete `LightingKitObject` class.
     */
    func lightingKitObject<T: LightingKitObject>() -> T {
        return T.init(name: self.name, id: self.uniqueIdentifier)
    }
}

extension HMHome: HomeKitObjectProtocol { }
extension HMRoom: HomeKitObjectProtocol { }

protocol HomeKitAccessoryProtocol: HomeKitObjectProtocol {
    var services: [HMService] { get }
}

extension HMAccessory: HomeKitAccessoryProtocol { }

/// An abstraction for HomeKit category objects
protocol HomeKitCategoryProtocol {
    var categoryType: String { get }
}

extension HomeKitCategoryProtocol {
    /// Indicates whether the category is associated with a LightBulb accessory.
    var isLighting: Bool {
        return categoryType == HMAccessoryCategoryTypeLightbulb
    }
}

extension HMAccessoryCategory: HomeKitCategoryProtocol { }

enum CharacteristicType {
    case power
    case brightness
    case unknown
}

protocol HomeKitCharacteristicProtocol {
    var characteristicType: String { get }
    var value: Any? { get }
    func writeValue(_ value: Any?, completionHandler completion: @escaping (Error?) -> Void)
}

extension HomeKitCharacteristicProtocol {
    var type: CharacteristicType {
        switch characteristicType {
        case HMCharacteristicTypePowerState: return .power
        case HMCharacteristicTypeBrightness: return .brightness
        default: return .unknown
        }
    }
}

extension HMCharacteristic: HomeKitCharacteristicProtocol { }
