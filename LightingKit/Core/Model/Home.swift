//
//  LKHome.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Represents a HomeKit home.
public struct Home: LightingKitObject {
    /// The name of the home.
    public let name: String
    /// The unique identifier of the home.
    public let id: UUID
    /**
     Initializes a `Home` object.
     - Parameters:
     - name: The name of the light.
     - id: The unique identifier for the light.
     - returns: An initialized `Home` object.
     */
    public init(name: String, id: UUID) {
        self.name = name
        self.id = id
    }
}

extension Home: Equatable {
    static func == (lhs: Home, rhs: HomeKitObjectProtocol) -> Bool {
        return lhs.id == rhs.uniqueIdentifier
    }
}
