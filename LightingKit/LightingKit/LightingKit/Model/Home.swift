//
//  LKHome.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

public protocol LightingKitObject {
    var name: String { get }
    var id: UUID { get }
    init(name: String, id: UUID)
}

public struct Home: LightingKitObject {
    public let name: String
    public let id: UUID
    public init(name: String, id: UUID) {
        self.name = name
        self.id = id
    }
}

extension Home: Equatable {
    static func == (lhs: Home, rhs: HomeKitObject) -> Bool {
        return lhs.id == rhs.uniqueIdentifier
    }
}
