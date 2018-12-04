//
//  MockCategory.swift
//  LightingKitTests
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit
@testable import LightingKit

class MockCategory: HomeKitCategoryProtocol {
    var isLight = false
    var testType: String?
    var categoryType: String {
        if let type = testType {
            return type
        } else {
            return isLight ? HMAccessoryCategoryTypeLightbulb : HMAccessoryCategoryTypeFan
        }
    }
}
