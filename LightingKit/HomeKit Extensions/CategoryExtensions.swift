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

extension HomeKitCategoryProtocol {
    /// Indicates whether the category is associated with a LightBulb accessory.
    var isLighting: Bool {
        return categoryType == HMAccessoryCategoryTypeLightbulb
    }
}

extension HMAccessoryCategory: HomeKitCategoryProtocol { }
