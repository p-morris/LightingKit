//
//  Light.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Represents a HomeKit light
public class Light: LightingKitObject {
    /// The name of the light
    public let name: String
    /// The unique identifier for the light
    public let uuid: UUID
    /// The `Power` object. Used to set the power state of the light.
    internal (set) public var power: Power?
    /// The `Brightness` object. Used to set the brightness state of the light.
    internal (set) public var brightness: Brightness?
    /**
     Initializes a `Light` object.
     - Parameters:
     - name: The name of the light.
     - id: The unique identifier for the light.
     - returns: An initialized `Light` object.
     */
    required public init(name: String, uuid: UUID) {
        self.name = name
        self.uuid = uuid
    }
}

extension Light: Equatable {
    public static func == (lhs: Light, rhs: Light) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    static func == (lhs: Light, rhs: HomeKitObjectProtocol) -> Bool {
        return lhs.uuid == rhs.uniqueIdentifier
    }
}
