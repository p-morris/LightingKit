//
//  AppRouter.swift
//  LightingKit Example
//
//  Created by Peter Morris on 26/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

protocol AppRouterDataSource: class {
    func homes() -> [Home]
    func rooms(for: Home) -> [Room]
    func lights(for: Room) -> [Light]
}

protocol Router {
    func route<T: LightingKitObject>(from vc: LightingKitTableViewController<T>, with object: T?)
}

class AppRouter: Router {
    weak var dataSource: AppRouterDataSource?
    private let nav: UINavigationController
    private let window: UIWindow
    private let factory: ControllerFactory
    init(window: UIWindow = UIWindow(),
         nav: UINavigationController = UINavigationController(),
         factory: ControllerFactory = ControllerFactory()) {
        self.nav = nav
        self.window = window
        self.factory = factory
    }
    
    func configureWindow() {
        guard let homes = dataSource?.homes() else { return }
        if let controller = factory.viewController(for: homes, router: self) {
            nav.viewControllers = [controller]
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
    func route<T: LightingKitObject>(from vc: LightingKitTableViewController<T>, with object: T?) {
        if let object = object {
            pushViewController(for: object)
        } else {
            presentAddAlert(from: vc)
        }
    }
    func presentAddAlert<T: LightingKitObject>(from vc: LightingKitTableViewController<T>) {
        switch vc {
        case is LightingKitTableViewController<Light>: break
        case is LightingKitTableViewController<Home>: presentAddObjectAlert(from: vc, isRoom: false)
        case is LightingKitTableViewController<Room>: presentAddObjectAlert(from: vc, isRoom: true)
        default: break
        }
        guard !(vc is LightingKitTableViewController<Light>) else { return }
        let alert = UIAlertController(title: "Enter name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            vc.dismiss(animated: true, completion: nil)
        }
        alert.addAction(add)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    func pushViewController<T: LightingKitObject>(for object: T) {
        guard let dataSource = dataSource else { return }
        var controller: UIViewController?
        switch object {
        case is Home: controller = factory.viewController(for: dataSource.rooms(for: object as! Home), router: self)
        case is Room: controller = factory.viewController(for: dataSource.lights(for: object as! Room), router: self)
        case is Light: controller = nil
        default: break
        }
        nav.pushViewControllerAnimated(controller)
    }
    func presentAddObjectAlert(from vc: UIViewController, isRoom: Bool) {
        let alert = UIAlertController(title: "Enter \(isRoom ? "Room" : "Home") name", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            if let name = alert.textFields?.first?.text, name.count > 0 {
                print("Add \(name)")
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    func presentAddLightController(from vc: UIViewController) {
        print("Add light")
    }
}
