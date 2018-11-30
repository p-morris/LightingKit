//
//  AccessoryExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 30/11/2018.
//

import Foundation
import HomeKit

extension HMAccessory {
    var isLighting: Bool {
        return category.categoryType == HMAccessoryCategoryTypeLightbulb ||
            isBridged && services.filter({ $0.isLighting }).count > 0
    }
}
