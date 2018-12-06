//
//  AppFacade.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit

class AppFacade {
    
    let window: UIWindow
    
    init(window: UIWindow = UIWindow()) {
        self.window = window
    }
    
    func startApp() {
        let homes = HomesViewController()
        let nav = UINavigationController(rootViewController: homes)
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
    
}
