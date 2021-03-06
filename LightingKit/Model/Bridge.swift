//
//  Bridge.swift
//  LightingKit
//
//  Created by Peter Morris on 29/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Represents a HomeKit bridge
public struct Bridge: LightingKitObject {
    /// The name of the bridge.
    public let name: String
    /// The unique identifier for the bridge.
    public let uuid: UUID
    /**
     Initializes a `Bridge` object.
     - Parameters:
     - name: The name of the bridge.
     - id: The unique identifier for the bridge.
     - returns: An initialized `Bridge` object.
     */
    public init(name: String, uuid: UUID) {
        self.name = name
        self.uuid = uuid
    }
}

extension Bridge: Equatable {
    static func == (lhs: Bridge, rhs: HomeKitObjectProtocol) -> Bool {
        return lhs.uuid == rhs.uniqueIdentifier
    }
}
