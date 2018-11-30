//
//  LightingKitObject.swift
//  LightingKit
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation

public protocol LightingKitObject {
    var name: String { get }
    var uuid: UUID { get }
    init(name: String, uuid: UUID)
}
