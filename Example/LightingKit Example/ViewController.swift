//
//  ViewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class ViewController: UIViewController, LightingKitDelegate {
    
    let kit = LightingKit()
    var lights: [Light] = []
    var homeNumber = 0
    var roomNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kit.delegate = self
    }
    
    @IBAction func configure() {
        if !kit.ready {
            kit.configureHomeKit()
        }
    }
    
    @IBAction func addHome() {
        homeNumber += 1
        kit.addHome(name: "Home \(homeNumber)") { (home) in
            if let home = home {
                print("Added home \(home)")
            } else {
                print("Failed to add home")
            }
        }
    }
    
    @IBAction func addRoom() {
        roomNumber += 1
        kit.addRoom(name: "Room \(roomNumber)", toHome: kit.homes.first!) { (room) in
            if let room = room {
                print("Add room \(room.name)")
            } else {
                print("Failed to add room.")
            }
        }
    }
    
    @IBAction func findLights() {
        kit.searchForNewLighting()
    }
    
    @IBAction func addNewLightToRoom() {
        let home = kit.homes.first!
        let room = kit.rooms(forHome: home).first!
        kit.add(light: lights.first!, toRoom: room) { (success) in
            if success {
                print("Added \(self.lights.first!.name) to \(room.name)")
            } else {
                print("Failed to add \(self.lights.first!.name) to \(room.name)")
            }
        }
    }
    
    @IBAction func listAccessories() {
        kit.homes.forEach {
            let home = $0
            print("Home \(home.name)")
            kit.lights(forHome: home).forEach({ (light) in
                print("- Light \(light.name)")
            })
            kit.rooms(forHome: home).forEach({ (room) in
                print("- - Room \(room.name)")
                kit.lights(forRoom: room).forEach({ (light) in
                    print("- - - \(light.name)")
                })
            })
        }
    }
    var on = false
    @IBAction func onoff() {
        on = true
        let home = kit.homes.first!
        kit.lights(forHome: home).forEach { (light) in
            light.power?.on(on, completion: { (error) in
                if let error = error {
                    print(error)
                } else {
                    print("Toggled power.")
                }
            })
        }
        
    }
    
    @IBAction func simpleBrightness() {
        let home = kit.homes.first!
        kit.lights(forHome: home).forEach { (light) in
            light.brightness?.set(brightness: 50, completion: { (error) in
                if let error = error {
                    print(error)
                } else {
                    print("Set brightness to 50")
                }
            })
        }
    }
    
    @IBAction func timedBrightness() {
        let home = kit.homes.first!
        kit.lights(forHome: home).forEach { (light) in
            light.power?.on(true, completion: { (error) in
                light.brightness?.set(brightness: 0, completion: { (error) in
                    light.brightness?.set(brightness: 100, duration: 10, brightnessDelegate: self)
                })
            })
        }
    }
    
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light) {
        lights.append(light)
        print("Found new light: \(light.name)")
    }
    
    func lightingKit(_ lightingKit: LightingKit, permissionsGranted: Bool) {
        print(permissionsGranted ? "LightingKit ready" : "LightingKit not ready")
    }

}

extension ViewController: TimedBrightnessUpdateDelegate {
    func brightness(_ brightness: Brightness, valueDidChange newValue: Int) {
        print(newValue)
    }
    
    func brightness(_ brightness: Brightness, didCompleteTimedUpdate newValue: Int) {
        print("Did complete timed brightness")
    }
    
    func brightness(_ brightness: Brightness, timedUpdateFailed error: Error?) {
        print("Timed update failiure")
    }
    
    
}
