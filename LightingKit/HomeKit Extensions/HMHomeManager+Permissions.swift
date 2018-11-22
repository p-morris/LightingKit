//
//  HMHomeManager+Permissions.swift
//  LightingKit
//
//  Created by Peter Morris on 22/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

extension HMHomeManager {
    var permissionGranted: Bool {
        let didUpdateHomes = value(forKey: "_didUpdateHomes") as? Bool
        return didUpdateHomes ?? false
    }
}
