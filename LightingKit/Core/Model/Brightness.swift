//
//  LightCharacteristic.swift
//  LightingKit
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

public protocol TimedBrightnessUpdateDelegate: class {
    /**
     Executed each time the brightness value is changed, during a timed brightness update.
     - Parameters:
     - brightness: The `Brightness` object whose timed update completed.
     - newValue: The new brightness value.
     */
    func brightness(_ brightness: Brightness, valueDidChange newValue: Int)
    /**
     Executed when a timed brightness update completes fully and successfully.
     - Parameters:
     - brightness: The `Brightness` object whose timed update completed.
     - newValue: The new brightness value.
     */
    func brightness(_ brightness: Brightness, didCompleteTimedUpdate newValue: Int)
    /**
     Executed when a timed brightness update fails.
     - Parameters:
     - brightness: The `Brightness` object whose timed update failed.
     - error: An optional error describing what went wrong.
     */
    func brightness(_ brightness: Brightness, timedUpdateFailed error: Error?)
}

/// Used to represent a `Light` object's brightness state.
public final class Brightness: Characteristic {
    /// The current brightness value.
    public var value: Int? {
        return homeKitCharacteristic.value as? Int
    }
    /// The `HMCharacteristic` that represents the light's brightness.
    internal let homeKitCharacteristic: HomeKitCharacteristicProtocol
    /// Used to slowly adjust the brightness value over a period of time.
    private var timer: Timer?
    /// The brightness value before the timed brightness update began
    private var startingBrightness: Int?
    /// The brightness that should be achieved during `duration`.
    private var targetBrightness: Int?
    /// The number of seconds it should take to achieve `targetBrightness`.
    private var duration: TimeInterval?
    /// The object that should act as the delegate for the timed update operation.
    private weak var delegate: TimedBrightnessUpdateDelegate?
    /**
     Initializes a `Brightness` object.
     - Parameters:
     - characteristic: The `HMCharacteristic` that represents the light's brightness state.
     - returns: An initialized `Brightness` object.
     */
    internal init?(homeKitCharacteristic: HomeKitCharacteristicProtocol) {
        guard homeKitCharacteristic.type == .brightness else {
            return nil
        }
        self.homeKitCharacteristic = homeKitCharacteristic
    }
    /**
     Sets the brightness of the `Light` to a new value **immediately**.
     - Parameters:
     - brightness: The new brightness value. 0-100.
     - completion: The closure that should be execute when the brightness value has been updated.
     - returns: An initialized `Brightness` object.
     */
    public func set(brightness: Int, completion: @escaping (Error?) -> Void) {
        homeKitCharacteristic.writeValue(brightness, completionHandler: completion)
    }
}

//MARK:- Timed Brightness Updates
extension Brightness {
    /**
     Sets the brightness of the `Light` to a new value incrementally over time.
     - Parameters:
     - brightness: The new brightness value. 0-100.
     - duration: The number of seconds it should take to achieve the desired brightness. Must be greater than 0.
     - delegate: The object which should act as the operation's delegate.
     - Note: Any timed brightness operations currently in operation will be cancelled, and the operation
     will start from the light's current brightness value.
     */
    public func set(brightness: Int, duration: TimeInterval, brightnessDelegate: TimedBrightnessUpdateDelegate) {
        // If `timer` is not nil, then another timed update is currently in progress.
        // Cancel that, and make a recursive call to set(brightness:duration:delegate).
        guard timer == nil else {
            timer?.invalidate()
            set(brightness: brightness, duration: duration, brightnessDelegate: brightnessDelegate)
            return
        }
        // We can't accept 0 as the duration for a timed updated.
        // Notify the delegate, passing an error.
        guard duration > 0 else {
            delegate?.brightness(self, timedUpdateFailed: LightingError.brightnessDuration)
            return
        }
        // Finally, we must be able to access the current brightness value. This should guard
        // should never fail.
        guard let currentBrightness = value else {
            delegate?.brightness(self, timedUpdateFailed: LightingError.unknownBrightness)
            return
        }

        let targetBrightness = brightness.sanitizedBrightness()
        scheduleBrightnessTimer(start: currentBrightness, end: targetBrightness, duration: duration, delegate: brightnessDelegate)
    }
    /**
     Schedules `timer` to update brightness over specified amount of time.
     - Parameters:
     - start: The starting brightness.
     - end: The value the brightness should be set to.
     - duration: The amount of time the change should take.
     - delegate: The object which should act as the operation's delegate.
     */
    private func scheduleBrightnessTimer(start: Int,
                                         end: Int,
                                         duration: TimeInterval,
                                         delegate: TimedBrightnessUpdateDelegate) {
        self.targetBrightness = end
        self.startingBrightness = start
        self.delegate = delegate
        timer = Timer.scheduledTimer(
            timeInterval: duration.incrementInterval(currentBrightness: start, targetBrightness: end),
            target: self,
            selector: #selector(updateTimedBrightness),
            userInfo: nil,
            repeats: true
        )
    }
    /**
     Increments or decrements the brightness by 1, depending on the values of
     `startingBrightness` and `targetBrightness`
     */
    @objc internal func updateTimedBrightness() {
        // If starting and target values are not set, then there's no operation ongoing,
        // and this was executed in error. Invalidate the timer.
        guard let end = targetBrightness, let start = startingBrightness else {
            cancelTimedBrightnessUpdate()
            return
        }
        // If we can't access the current brightness value, then there's a problem. Cancel
        // the operation and notify the delegate of the error.
        guard let current = value else {
            cancelTimedBrightnessUpdate()
            delegate?.brightness(self, timedUpdateFailed: LightingError.unknownBrightness)
            return
        }
        // If the start and end brightness match then we don't want to update them any more!
        guard current != end else {
            delegate?.brightness(self, didCompleteTimedUpdate: current)
            cancelTimedBrightnessUpdate()
            return
        }
        
        let newBrightness = end > start ? current + 1 : current - 1
        set(brightness: newBrightness, completion: brightnessIncremented)
        
    }
    /**
     Notifies the delegate of the current start of the timed brightness update operation.
     - Parameters:
     - error: An optional `Error`, or `nil` if no error has occured on this increment.
     */
    private func brightnessIncremented(error: Error?) {
        guard error == nil, let newValue = value else {
            cancelTimedBrightnessUpdate()
            delegate?.brightness(self, timedUpdateFailed: error ?? LightingError.unknownBrightness)
            return
        }
        delegate?.brightness(self, valueDidChange: newValue)
    }
    /**
     Cancels any pending timed brightness update.
     */
    public func cancelTimedBrightnessUpdate() {
        timer?.invalidate()
        timer = nil
        startingBrightness = nil
        targetBrightness = nil
        delegate = nil
    }
}
