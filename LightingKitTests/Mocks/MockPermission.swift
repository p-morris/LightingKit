//
//  MockPermission.swift
//  LightingKitTests
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
@testable import LightingKit

class MockPermission: HomeKitPermission {
    var requested = false
    var success = true
    func requestPermission(homeManager: HomeManagerProtocol, completion: @escaping (Bool) -> Void) {
        requested = true
        completion(success)
    }
}
