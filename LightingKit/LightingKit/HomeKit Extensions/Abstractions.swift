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
    init()
}

extension HMHomeManager: HomeManagerProtocol { }

/// An abstraction for HomeKit objects
internal protocol HomeKitObject {
    var name: String { get }
    var uniqueIdentifier: UUID { get }
}

extension HMHome: HomeKitObject { }
extension HMRoom: HomeKitObject { }
extension HMAccessory: HomeKitObject { }
