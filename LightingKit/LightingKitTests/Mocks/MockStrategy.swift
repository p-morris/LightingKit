//
//  MockStrategy.swift
//  LightingKitTests
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
@testable import LightingKit

class MockStrategy: SuccessStrategy {
    var shouldSucceed = false
    func success(manager: HomeManagerProtocol) -> Bool {
        return shouldSucceed
    }
}
