//
//  HomeKitExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

protocol HomeManagerProtocol {
    var delegate: HMHomeManagerDelegate? { get set }
    var homes: [HMHome] { get }
}

extension HMHomeManager: HomeManagerProtocol { }
