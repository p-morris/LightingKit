//
//  ServiceBuilderChain.swift
//  LightingKit
//
//  Created by Peter Morris on 04/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Used to assign services to a `Light` object.
protocol ServiceHandler {
    /**
     Assigns a service to `light`, based on `characteristic`. If no service is assigned, the request is
     passed on to `sucessor`
     - Parameters:
     - light: The `Light` object to assign a service to.
     - characteristic: The characteristic that controls the service.
     - successor: A `ServiceHandler` to pass the request to, in the event that the service is not assigned.
     */
    func assignService(to light: Light, with characteristic: HomeKitCharacteristicProtocol?, successor: ServiceHandler?)
}

/// Used to assign a `Power` service to a `Light`
class PowerServiceHandler: ServiceHandler {
    func assignService(to light: Light,
                       with characteristic: HomeKitCharacteristicProtocol?,
                       successor: ServiceHandler?) {
        guard let power = Power(homeKitCharacteristic: characteristic) else {
            successor?.assignService(to: light, with: characteristic, successor: nil)
            return
        }
        light.power = power
    }
}

/// Used to assign a `Brightness` service to a `Light`
class BrightnessServiceHandler: ServiceHandler {
    func assignService(to light: Light,
                       with characteristic: HomeKitCharacteristicProtocol?,
                       successor: ServiceHandler?) {
        guard let brightness = Brightness(homeKitCharacteristic: characteristic) else {
            successor?.assignService(to: light, with: characteristic, successor: nil)
            return
        }
        light.brightness = brightness
    }
}

/// Used to assign services to `Light`
protocol HomeKitServiceBuilder {
    /// The `ServiceHandler` objects to use to assign services
    var handlers: [ServiceHandler] { get }
    /**
     Assigns services to a `Light` based on an array of `HomeKitCharacteristicProtocol` objects.
     - Parameters:
     - light: The `Light` object to assign services to.
     - characteristics: The characteristics that controls the services that should be assigned.
     */
    func assignServices(to light: Light, with characteristics: [HomeKitCharacteristicProtocol]?)
}
