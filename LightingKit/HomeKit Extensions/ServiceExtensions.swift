//
//  CategoryExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// An abstraction for HomeKit category objects
protocol HomeKitServiceProtocol {
    var serviceType: String { get }
}

extension HomeKitServiceProtocol {
    /// Indicates whether the service is associated with a LightBulb accessory.
    var isLighting: Bool {
        return serviceType == HMServiceTypeLightbulb
    }
}

extension HMService: HomeKitServiceProtocol { }
