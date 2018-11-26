//
//  AppRouter.swift
//  LightingKit Example
//
//  Created by Peter Morris on 26/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class AppRouter {
    private let kit: LightingKit
    private let nav: UINavigationController
    private let window: UIWindow
    private let factory: ControllerFactory
    init(kit: LightingKit = LightingKit(),
         window: UIWindow = UIWindow(),
         nav: UINavigationController = UINavigationController(),
         factory: ControllerFactory = ControllerFactory()) {
        self.kit = kit
        self.nav = nav
        self.window = window
        self.factory = factory
    }
    func configure() {
        kit.delegate = self
        kit.configureHomeKit()
    }
    func configureWindow() {
        let model = LightingKitViewModel(title: "Homes", router: self, objects: kit.homes)
        let controller = LightingKitTableViewController(viewModel: model)
        nav.viewControllers = [controller]
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
    func pushViewController<T: LightingKitObject>(for object: T) {
        var controller: UIViewController?
        switch object {
        case is Home: controller = factory.viewController(for: kit.rooms(forHome: object as! Home), router: self)
        case is Room: controller = factory.viewController(for: kit.lights(forRoom: object as! Room), router: self)
        case is Light: controller = nil
        default: break
        }
        nav.pushViewControllerAnimated(controller)
    }
}

extension AppRouter: LightingKitDelegate {
    func lightingKit(_ lightingKit: LightingKit, permissionsGranted: Bool) {
        configureWindow()
    }
    
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light) {
        //
    }
}
