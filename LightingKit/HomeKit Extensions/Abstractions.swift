//
//  Abstractions.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// An abstraction for `HMHomeManager`
internal protocol HomeManagerProtocol {
    var delegate: HMHomeManagerDelegate? { get set }
    var homes: [HMHome] { get }
    var permissionGranted: Bool { get }
    init()
}

extension HMHomeManager: HomeManagerProtocol { }

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
extension HMAccessory: HomeKitObjectProtocol { }
