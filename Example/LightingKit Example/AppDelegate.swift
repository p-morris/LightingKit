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
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let facade = AppFacade()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        facade.startApp()
        return true
    }

}

