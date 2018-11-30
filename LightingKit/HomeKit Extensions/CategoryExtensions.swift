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
protocol HomeKitCategoryProtocol {
    var categoryType: String { get }
}

// FIXME: Better to use a type enum if we need to test for different types.
extension HomeKitCategoryProtocol {
    // FIXME: Bridged accessories always return HMAccessoryCategoryTypeOther. Need to change this logic.
    /// Indicates whether the category is associated with a LightBulb accessory.
    var isLighting: Bool {
        return categoryType == HMAccessoryCategoryTypeLightbulb
    }
    /// Indicates whether the category is associated with a Bridge accessory.
    var isBridge: Bool {
        return categoryType == HMAccessoryCategoryTypeBridge
    }
}

extension HMAccessoryCategory: HomeKitCategoryProtocol { }
