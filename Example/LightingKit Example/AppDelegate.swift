//
//  AppDelegate.swift
//  LightingKit Example
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LightingKitPermissionsDelegate, LightingKitDelegate {
    
    let facade = AppFacade()
    let lightingKit = LightingKit()
    var room: Room?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        facade.startApp()
        lightingKit.delegate = self
        lightingKit.configureHomeKit()
        return true
    }
    
    func lightingKit(_ lightingKit: LightingKit, permissionsGranted: Bool) {
        if permissionsGranted {
            lightingKit.addHome(name: "Pete's Flat") { (home) in
                if let home = home {
                    self.lightingKit.addRoom(name: "Bedroom", toHome: home, completion: { (room) in
                        if let room = room {
                            self.room = room
                            self.lightingKit.searchForNewLighting()
                        }
                    })
                }
            }
        }
    }
    
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light) {
        if let room = room {
            lightingKit.add(light: light, toRoom: room) { (success) in
                print(success ? "Yay" : "Fuck")
            }
        }
    }

}

