//
//  AppFacade.swift
//  LightingKit Example
//
//  Created by Peter Morris on 26/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class AppFacade {
    private let kit: LightingKit
    let router: AppRouter
    private let app: UIApplication
    init(router: AppRouter = AppRouter(), app: UIApplication = UIApplication.shared, kit: LightingKit = LightingKit()) {
        self.router = router
        self.app = app
        self.kit = kit
    }
    func startApp() {
        router.dataSource = self
        kit.delegate = self
        kit.configureHomeKit()
    }
}

extension AppFacade: LightingKitDelegate {
    func lightingKit(_ lightingKit: LightingKit, permissionsGranted: Bool) {
        router.configureWindow()
    }
    
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light) {
        //
    }
}
extension AppFacade: AppRouterDataSource {
    func homes() -> [Home] {
        return kit.homes
    }
    func rooms(for home: Home) -> [Room] {
        return kit.rooms(forHome: home)
    }
    func lights(for room: Room) -> [Light] {
        return kit.lights(forRoom: room)
    }
}
