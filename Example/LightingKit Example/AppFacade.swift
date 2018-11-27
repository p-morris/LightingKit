//
//  AppFacade.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import LightingKit

class AppFacade {
    let window: UIWindow
    let kit: LightingKit
    init(window: UIWindow = UIWindow(), kit: LightingKit = LightingKit()) {
        self.window = window
        self.kit = kit
    }
    func startApp() {
        kit.delegate = self
        kit.configureHomeKit()
    }
    func configureWindow() {
        let dataSource = DataSource(objects: kit.homes)
        let routes = AppRoutes(kit: kit)
        let homes = LightingKitController<Home, Home>(dataSource: dataSource, routes: routes)
        let nav = UINavigationController()
        nav.viewControllers = [homes]
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}

extension AppFacade: LightingKitDelegate {
    func lightingKit(_ lightingKit: LightingKit, permissionsGranted: Bool) {
        if permissionsGranted {
            configureWindow()
        }
    }
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light) {
        //
    }
}
