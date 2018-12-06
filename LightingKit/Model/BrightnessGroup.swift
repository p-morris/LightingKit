//
//  BrightnessGroup.swift
//  LightingKit
//
//  Created by Peter Morris on 05/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation

protocol TimedBrightnessGroupUpdateDelegate: class {
    func brightnessGroup(_ group: BrightnessGroup, didCompleteTimedBrightnessUpdate errors: [Error]?)
}

/// Represents a group of brightness services for grouped lights.
public class BrightnessGroup: CharacteristicGroup {
    typealias CharacteristicType = Brightness
    /// The brightness services of the group
    let services: [Brightness]
    /// The brightness delegate
    private weak var delegate: TimedBrightnessGroupUpdateDelegate?
    /// The number of services currently undergoing a timed brightness update
    private var updatingServices = 0 {
        didSet {
            if updatingServices == 0 {
                let errors: [Error]? = updateErrors.count > 0 ? updateErrors : nil
                delegate?.brightnessGroup(self, didCompleteTimedBrightnessUpdate: errors)
                updateErrors.removeAll()
            }
        }
    }
    /// Any errors that occured during a timed update
    private var updateErrors: [Error] = []
    /**
     Initializes a `BrightnessGroup` object.
     - Parameters:
     - services: The brightness services for the group.
     - returns: An initialized `BrightnessGroup` object if `services` contains at least one service,
     nil otherwise.
     */
    required init?(services: [Brightness]) {
        guard services.count > 0 else { return nil }
        self.services = services
    }
    /**
     Sets the brightness of all the lights in the group to a new value **immediately**.
     - Parameters:
     - brightness: The new brightness value. 0-100.
     - completion: The closure that should be execute when the brightness value has been updated.
     */
    public func set(brightness: Int, completion: @escaping ([Error]?) -> Void) {
        var errors: [Error] = []
        for (index, service) in services.enumerated() {
            service.set(brightness: brightness) { error in
                if let error = error { errors.append(error) }
                if index == self.services.count - 1 {
                    completion(errors.count > 0 ? errors : nil)
                }
            }
        }
    }
}

extension BrightnessGroup: TimedBrightnessUpdateDelegate {
    /**
     Sets the brightness of all the lights in the group to a new value incrementally over time.
     - Parameters:
     - brightness: The new brightness value. 0-100.
     - duration: The number of seconds it should take to achieve the desired brightness. Must be greater than 0.
     - delegate: The object which should act as the operation's delegate.
     - Note: Any timed brightness operations currently in operation will be cancelled, and the operation
     will start from the light's current brightness value.
     */
    public func set(brightness: Int, duration: TimeInterval, brightnessDelegate: TimedBrightnessUpdateDelegate) {
        updatingServices = services.count
        services.forEach { service in
            service.delegate = self
            service.set(brightness: brightness, duration: duration, brightnessDelegate: brightnessDelegate)
        }
    }
    public func brightness(_ brightness: Brightness, valueDidChange newValue: Int) {
        // No action to take here
    }
    public func brightness(_ brightness: Brightness, timedUpdateFailed error: Error?) {
        if let error = error {
            updateErrors.append(error)
        }
        updatingServices -= 1
    }
    public func brightness(_ brightness: Brightness, didCompleteTimedUpdate newValue: Int) {
        updatingServices -= 1
    }
}
