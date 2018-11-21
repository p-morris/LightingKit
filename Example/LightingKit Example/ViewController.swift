//
//  ViewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class ViewController: UIViewController {
    
    let kit = LightingKit()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func go() {
        if let home = kit.homes.first {
            kit.rooms(forHome: home).forEach {
                print($0.name + " " + $0.id.uuidString)
                print("------- LIGHTS ------")
                kit.lights(forRoom: $0).forEach {
                    print($0.name + " " + $0.id.uuidString)
                }
            }
        }
    }

}

