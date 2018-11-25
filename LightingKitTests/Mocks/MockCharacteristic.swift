//
//  MockCharacteristic.swift
//  LightingKitTests
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit
@testable import LightingKit

class MockCharacteristic: HomeKitCharacteristicProtocol {
    var characteristicType: String = HMCharacteristicTypePowerState
    var value: Any?
    var didWriteValue = false
    func writeValue(_ value: Any?, completionHandler completion: @escaping (Error?) -> Void) {
        didWriteValue = true
        completion(nil)
    }
}
