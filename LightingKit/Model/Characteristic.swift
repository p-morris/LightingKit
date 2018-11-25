//
//  Characteristic.swift
//  LightingKit
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

protocol Characteristic {
    var homeKitCharacteristic: HomeKitCharacteristicProtocol { get }
    init?(homeKitCharacteristic: HomeKitCharacteristicProtocol?)
}
