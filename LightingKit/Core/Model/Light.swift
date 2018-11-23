//
//  Light.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

protocol LightDelegate: class {
    func light(_ light: Light, completedPowerUpdate: Error?)
    func light(_ light: Light, completedBrightnessUpdate: Error?)
    func light(_ light: Light, completedTimedBrightnessUpdate error: Error?)
}

public class Light: LightingKitObject {
    weak var delegate: LightDelegate?
    public let name: String
    public let id: UUID
    internal var _power: HMCharacteristic?
    internal var _brightness: HMCharacteristic?
    private var timer: Timer?
    private var targetBrightness: Int?
    required public init(name: String, id: UUID) {
        self.name = name
        self.id = id
    }
}

extension Light {
    public func set(powerOn on: Bool) {
        _power?.writeValue(on) { error in
            self.delegate?.light(self, completedPowerUpdate: error)
        }
    }
    public func set(brightness: Int) {
        _brightness?.writeValue(brightness) { error in
            self.delegate?.light(self, completedBrightnessUpdate: error)
        }
    }
    public func set(brightness: Int, duration: TimeInterval) {
        guard duration > 0 else {
            set(brightness: brightness)
            return
        }
        
        let targetBrightness = Double(brightness)
        let timeIncrement = TimeInterval(round(duration / targetBrightness))
        self.targetBrightness = brightness
        timer = Timer.scheduledTimer(
            timeInterval: timeIncrement,
            target: self,
            selector: #selector(updateTimedBrightness),
            userInfo: nil,
            repeats: true
        )
    }
    @objc internal func updateTimedBrightness() {
        guard let targetBrightness = targetBrightness,
            let brightness = _brightness,
            let currentBrightness = brightness.value as? Int,
            currentBrightness < targetBrightness else {
            delegate?.light(self, completedTimedBrightnessUpdate: nil)
            cancelTimedBrightnessUpdate()
            return
        }
        set(brightness: currentBrightness + 1)
    }
    public func cancelTimedBrightnessUpdate() {
        timer?.invalidate()
        timer = nil
    }
}

extension Light: Equatable {
    public static func == (lhs: Light, rhs: Light) -> Bool {
        return lhs.id == rhs.id
    }
    static func == (lhs: Light, rhs: HomeKitObjectProtocol) -> Bool {
        return lhs.id == rhs.uniqueIdentifier
    }
}
