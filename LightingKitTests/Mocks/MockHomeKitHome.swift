//
//  MockHome.swift
//  LightingKitTests
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit
@testable import LightingKit

struct MockHomeKitObject: HomeKitObjectProtocol {
    let uniqueIdentifier: UUID
    let name: String
}

struct MockLightingKitObject: LightingKitObject {
    let name: String
    let id: UUID
    init(name: String, id: UUID) {
        self.name = name
        self.id = id
    }
}
