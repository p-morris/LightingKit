//
//  HMHomeManagerExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 23/11/2018.
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
    func addHome(withName homeName: String, completionHandler completion: @escaping (HMHome?, Error?) -> Void)
}

extension HMHomeManager: HomeManagerProtocol { }

extension HMHomeManager {
    var permissionGranted: Bool {
        let didUpdateHomes = value(forKey: "_didUpdateHomes") as? Bool
        return didUpdateHomes ?? false
    }
}
