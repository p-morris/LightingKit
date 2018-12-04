//
//  CategoryExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Represents a category type for Homekit accessories
enum HomeKitCategoryType {
    case lighting
    case bridge
    case other
    case none
}

/// An abstraction for HomeKit category objects
protocol HomeKitCategoryProtocol {
    var categoryType: String { get }
}

extension HomeKitCategoryProtocol {
    /// Used to represent the type of the category
    var type: HomeKitCategoryType {
        switch categoryType {
        case HMAccessoryCategoryTypeLightbulb: return .lighting
        case HMAccessoryCategoryTypeBridge: return .bridge
        case HMAccessoryCategoryTypeOther: return .other
        default: return .none
        }
    }

}

extension HMAccessoryCategory: HomeKitCategoryProtocol { }
