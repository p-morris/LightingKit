//
//  LightingKit.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

public final class LightingKit: NSObject {
    private var homeManager: HomeManagerProtocol?
    private var permission: LightingKitPermission?
    public var ready: Bool {
        return homeManager != nil
    }
    public var homes: [Home] {
        return homeManager?.homes.lightingKitObjects() ?? []
    }
    public override init() {
        super.init()
        configure()
    }
    internal func configure(permission: LightingKitPermission = LightingKitPermission(),
                            managerType: HomeManagerProtocol.Type = HMHomeManager.self) {
        self.permission = permission
        permission.requestPermission { success in
            if success {
                self.homeManager = managerType.init()
                self.homeManager?.delegate = self
            }
        }
    }
    public func rooms(forHome home: Home) -> [Room] {
        return homeManager?.homes.rooms(for: home) ?? []
    }
    public func lights(forRoom room: Room) -> [Light] {
        return homeManager?.homes.lightingKitLights(for: room) ?? []
    }
}

extension LightingKit: HMHomeManagerDelegate {

}
