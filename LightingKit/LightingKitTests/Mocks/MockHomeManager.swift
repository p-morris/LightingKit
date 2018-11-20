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
    var homes: [HMHome] = []
    weak var delegate: HMHomeManagerDelegate?
    func notifyDelegate() {
        delegate?.homeManagerDidUpdateHomes?(HMHomeManager())
    }
}
