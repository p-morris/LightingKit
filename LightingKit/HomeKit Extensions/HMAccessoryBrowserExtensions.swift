//
//  HMAccessoryBrowserExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

internal protocol HomeKitAccessoryBrowserProtocol {
    var delegate: HMAccessoryBrowserDelegate? { get set }
    func stopSearchingForNewAccessories()
    func startSearchingForNewAccessories()
}

extension HMAccessoryBrowser: HomeKitAccessoryBrowserProtocol { }
