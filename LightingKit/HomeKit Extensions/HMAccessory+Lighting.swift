//
//  HMAccessory+Lighting.swift
//  LightingKit
//
//  Created by Peter Morris on 22/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import HomeKit

extension HMAccessory {
    var isLighting: Bool {
        return services.contains { $0.serviceType == HMServiceTypeLightbulb }
    }
}
