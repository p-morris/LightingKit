//
//  Error.swift
//  LightingKit
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation

/// Used to represent LightingKit errors.
enum LightingError {
    /// An error indicating that an invalid duration was used for a timed brightness update.
    static let brightnessDuration = NSError(
        domain: "BrightnessInvalidDuration",
        code: 1,
        userInfo: [NSLocalizedDescriptionKey: "The duration must be greater than 0."]
    )
    /// An error indicating that there was a problem accessing the current brightness value of a light.
    static let unknownBrightness = NSError(
        domain: "BrightnessUnknown",
        code: 2,
        userInfo: [
            NSLocalizedDescriptionKey: "Unable to access current brightness value of lighting. Communication error."
        ]
    )
}
