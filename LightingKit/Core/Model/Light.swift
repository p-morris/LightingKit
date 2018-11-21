//
//  Light.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation

public struct Light: LightingKitObject {
    public let name: String
    public let id: UUID
    public init(name: String, id: UUID) {
        self.name = name
        self.id = id
    }
}
