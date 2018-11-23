//
//  LightingKitPermissions.swift
//  LightingKit
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

internal protocol HomeKitPermission {
    func requestPermission(homeManager: HomeManagerProtocol, completion: @escaping (Bool) -> Void)
}

/// Used to request permission from the user for HomeKit access
internal final class LightingKitPermission: NSObject, HomeKitPermission {
    typealias PermissionCompletion = (Bool) -> Void
    /// The `HMHomeManager` to use for requesting permission
    private var homeManager: HomeManagerProtocol?
    /// The closure to execute when permission has been granted or denied
    private var completion: PermissionCompletion?
    /// The strategy used to determine whether permission was successfully granted
    private let strategy: SuccessStrategy
    /**
     Initializes a new `LightingKitPermission` object.
     - Parameters:
     - homeManager: The `HMHomeManager` to use for requesting HomeKit permissions.
     - strategy: The `SuccessStrategy` to use to determine whether permission is granted.
     - permissionCompletion: The closure to execute when permission request completes.
     If access was granted, `true` will be passed, othewise `false`.
     - Returns: An initialized `LightingKitPermission` object.
     - Warning: The `permissionCompletion` closure is escaping, retained, and a reference to it is held for the
     lifetime of the object. Any objects used within should be declared `weak` or `unowned`.
     */
    internal init(strategy: SuccessStrategy = HomeKitPermissionSuccessStrategy()) {
        self.strategy = strategy
        super.init()
    }
    /**
     Requests HomeKit permission for the application.
     - Parameters:
     - homeManager: The `HMHomeManager` to use for requesting HomeKit permissions.
     - completion: The closure to execute when permission request completes.
     If access was granted, `true` will be passed, othewise `false`.
     - Warning: A reference to the `completion` closure is kept after escaping and therefore any references to
     `self` within *will* be captured.
     - Warning: The application's Info.plist file must contain the `NSHomeKitUsageDescription` key
     and a corresponding value, else the application will exit immediately on execution of this method.
     */
    internal func requestPermission(homeManager: HomeManagerProtocol,
                           completion: @escaping PermissionCompletion) {
        self.homeManager = homeManager
        self.homeManager?.delegate = self
        self.completion = completion
    }
}

extension LightingKitPermission: HMHomeManagerDelegate {
    /// Sets the `homeManager` delegate to nil, determines whether
    /// permission was granted successfully, and then executes `completion`/.
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        completion?(strategy.success(manager: manager))
        completion = nil
        homeManager?.delegate = nil
    }
}
