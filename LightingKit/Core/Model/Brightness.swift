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
    func brightness(_ brightness: Brightness, didCompleteTimedUpdate newValue: Int)
    func brightness(_ brightness: Brightness, timedUpdateFailed error: Error?)
}

/// Used to represent a `Light` object's brightness state.
public final class Brightness {
    /// The `HMCharacteristic` that represents the light's brightness.
    private let characteristic: HMCharacteristic
    /**
     Initializes a `Brightness` object.
     - Parameters:
     - characteristic: The `HMCharacteristic` that represents the light's brightness state.
     - returns: An initialized `Brightness` object.
     */
    internal init(characteristic: HMCharacteristic) {
        self.characteristic = characteristic
    }
    /**
     Sets the brightness of the `Light` to a new value **immediately**.
     - Parameters:
     - brightness: The new brightness value. 0-100.
     - completion: The closure that should be execute when the brightness value has been updated.
     - returns: An initialized `Brightness` object.
     */
    public func set(brightness: Int, completion: @escaping (Error?) -> Void) {
        characteristic.writeValue(brightness, completionHandler: completion)
    }
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
     Sets the brightness of the `Light` to a new value incrementally over time.
     - Parameters:
     - brightness: The new brightness value. 0-100.
     - duration: The number of seconds it should take to achieve the desired brightness.
     - delegate: The object which should act as the operation's delegate.
     - Note: Any timed brightness operations currently in operation will be cancelled, and the operation
     will start from the light's current brightness value.
     - Note: If `duration` is 0, the brightness will be set to the new value **immediately**.
     */
    public func set(brightness: Int, duration: TimeInterval, brightnessDelegate: TimedBrightnessUpdateDelegate) {
        guard timer == nil else {
            timer?.invalidate()
            set(brightness: brightness, duration: duration, brightnessDelegate: brightnessDelegate)
            return
        }
        guard duration > 0 else {
            set(brightness: brightness) { error in
                if error != nil { brightnessDelegate.brightness(self, timedUpdateFailed: error) }
                else { brightnessDelegate.brightness(self, didCompleteTimedUpdate: brightness) }
            }
            return
        }
        guard let currentValue = characteristic.value as? Int else {
            return
        }
        
        let target = (brightness < 0 ? 0 : (brightness > 100 ? 100 : brightness))
        targetBrightness = target
        startingBrightness = currentValue
        delegate = brightnessDelegate
        let interval = duration.incrementInterval(currentBrightness: currentValue, targetBrightness: target)
        timer = Timer.scheduledTimer(
            timeInterval: interval,
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
    @objc func updateTimedBrightness() {
        guard let target = targetBrightness,
            let starting = startingBrightness,
            let currentBrightness = characteristic.value as? Int else {
                return
        }
        guard currentBrightness != target else {
            delegate?.brightness(self, didCompleteTimedUpdate: currentBrightness)
            cancelTimedBrightnessUpdate()
            return
        }
        
        let completion = { (error: Error?) in
            if error != nil {
                self.delegate?.brightness(self, timedUpdateFailed: error)
                self.timer?.invalidate()
            }
        }
        
        if target > starting {
            characteristic.writeValue(currentBrightness + 1, completionHandler: completion)
        } else {
            characteristic.writeValue(currentBrightness - 1, completionHandler: completion)
        }
        
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
