//
//  ServiceFactory.swift
//  LightingKit
//
//  Created by Peter Morris on 05/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

class LightServiceFactory: HomeKitServiceBuilder {
    /// The `ServiceHandler` objects to use for building services.
    let handlers: [ServiceHandler]
    /**
     Initializes a `LightServiceBuilder` object.
     - Parameters:
     - handlers: The `ServiceHandler` objects to use to build services.
     - returns: An initialized `LightServiceBuilder` object.
     */
    init(handlers: [ServiceHandler] = [PowerServiceHandler(), BrightnessServiceHandler()]) {
        self.handlers = handlers
    }
    func assignServices(to light: Light, with characteristics: [HomeKitCharacteristicProtocol]?) {
        guard let characteristics = characteristics else { return }
        characteristics.forEach {
            for (index, handler) in handlers.enumerated() {
                let nextIndex = index + 1
                let successorIndex = nextIndex < handlers.count ? handlers[nextIndex] : nil
                handler.assignService(to: light, with: $0, successor: successorIndex)
            }
        }
    }
}
