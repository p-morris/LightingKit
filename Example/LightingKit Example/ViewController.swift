//
//  ViewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import HomeKit
import LightingKit

class ViewController: UIViewController, LightingKitDelegate, HMHomeManagerDelegate {
    
    //let kit = LightingKit()
    let hm = HMHomeManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func go() {
        hm.delegate = self
        hm.permission()
//        kit.delegate = self
//        kit.searchForNewLighting()
//        if let home = kit.homes.first {
//            kit.rooms(forHome: home).forEach {
//                print($0.name + " " + $0.id.uuidString)
//                print("------- LIGHTS ------")
//                kit.lights(forRoom: $0).forEach {
//                    print($0.name + " " + $0.id.uuidString)
//                }
//            }
//        }
    }
    
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light) {
        print(light.name)
    }

}
