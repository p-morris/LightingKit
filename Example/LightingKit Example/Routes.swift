//
//  Routes.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import LightingKit

protocol Routes {
    var kit: LightingKit { get }
    func route<T>(from parent: T?, pushOn nav: UINavigationController?) where T: LightingKitObject
    func route<T>(from parent: T?, presentOn controller: UIViewController) where T: LightingKitObject
}

class AppRoutes: Routes {
    let kit: LightingKit
    init(kit: LightingKit) {
        self.kit = kit
    }
    func route<T>(from parent: T?, pushOn nav: UINavigationController?) where T: LightingKitObject {
        switch parent {
        case is Home:
            let roomSource = DataSource(objects: kit.rooms(forHome: parent as! Home))
            let rooms = LightingKitController<Room, Home>(dataSource: roomSource, routes: self)
            nav?.pushViewController(rooms, animated: true)
        case is Room:
            let lightSource = DataSource(objects: kit.lights(forRoom: parent as! Room))
            let lights = LightingKitController<Light, Room>(dataSource: lightSource, routes: self)
            nav?.pushViewController(lights, animated: true)
        case is Light:
            let lightControls = LightControlsController(light: parent as! Light)
            nav?.pushViewController(lightControls, animated: true)
        default: break
        }
    }
    func route<T>(from parent: T?, presentOn controller: UIViewController) where T : LightingKitObject {
        switch parent {
        case nil:
            let alert = UIAlertController(title: "Add new Home")
            alert.addObjectAction { name in
                self.kit.addHome(name: name) { _ in

                }
            }
            controller.present(alert, animated: true, completion: nil)
        case is Home:
            let alert = UIAlertController(title: "Add new Room")
            alert.addObjectAction { name in
                self.kit.addHome(name: name) { _ in
                    
                }
            }
            controller.present(alert, animated: true, completion: nil)
        case is Room:
            let addLights = AddLightController()
            controller.present(addLights, animated: true, completion: nil)
        default: break
        }
    }
}
