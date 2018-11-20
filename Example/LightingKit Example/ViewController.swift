//
//  ViewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit
import HomeKit

class ViewController: UIViewController, HMHomeManagerDelegate {
    
    var permission: LightingKitPermission!
    var homeManager: HMHomeManager!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        permission = LightingKitPermission(permissionCompletion: { (complete) in
            print("Permission \(complete ? "granted" : "failed")")
            self.homeManager = HMHomeManager()
            self.homeManager.delegate = self
        })
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        print("DID UPDATE HOMES")
    }

}

