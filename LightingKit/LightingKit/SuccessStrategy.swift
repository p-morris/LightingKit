//
//  SuccessStrategy.swift
//  LightingKit
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation

/// Used to determine whether HomeKit permissions were successfully
/// granted to the app.
internal protocol SuccessStrategy {
    /**
     Indicates whether HomeKit permission have been granted.
     - Parameters:
     - homeManager: The `HMHomeManager` to use to determine whether permissions are granted.
     - Returns: `true` if HomeKit permissions have been granted, `false` otherwise.
     */
    func success(manager: HomeManagerProtocol) -> Bool
}

internal final class HomeKitPermissionSuccessStrategy: SuccessStrategy {
    /// Returns `true` if `manager.homes.count` is greater than 0.
    func success(manager: HomeManagerProtocol) -> Bool {
        return manager.homes.count > 0
    }
}
