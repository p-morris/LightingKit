//
//  MockHomeManager.swift
//  LightingKitTests
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit
@testable import LightingKit

class MockHomeManager: HomeManagerProtocol {
    var addedHome = false
    func addHome(withName homeName: String, completionHandler completion: @escaping (HMHome?, Error?) -> Void) {
        addedHome = true
        completion(nil, nil)
    }
    var shouldGrantPermission = true
    var permissionGranted: Bool { return shouldGrantPermission }
    var homes: [HMHome] = []
    weak var delegate: HMHomeManagerDelegate?
    required init() {
        //
    }
    func notifyDelegate() {
        delegate?.homeManagerDidUpdateHomes?(HMHomeManager())
    }
}

class MockAddHomeCompletion {
    var called = false
    func completion(home: Home?) -> Void {
        called = true
    }
}
