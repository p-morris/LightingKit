//
//  LightControlsViewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class LightControlsViewController: UIViewController, TimedBrightnessUpdateDelegate {
    
    let kit: LightingKit
    let light: Light
    @IBOutlet var power: UISwitch!
    @IBOutlet var brightness: UISlider!
    @IBOutlet var lightBulb: UIImageView!
    @IBOutlet var timerButton: UIButton!
    
    init(kit: LightingKit, light: Light) {
        self.kit = kit
        self.light = light
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = light.name.capitalized
        power.isOn = light.power?.on ?? false
        let brightnessValue = Float(light.brightness?.value ?? 0)
        brightness.setValue(brightnessValue, animated: false)
        setLightbulbBrightness()
        lightBulb.image = lightBulb.image?.withRenderingMode(.alwaysTemplate)
        lightBulb.tintColor = UIColor.yellow
    }
    
    @IBAction func setPower() {
        light.power?.on(power.isOn) { error in
            self.setLightbulbBrightness()
        }
    }
    
    @IBAction func brightnessChanged() {
        let brightnessValue = Int(roundf(brightness.value))
        light.brightness?.set(brightness: brightnessValue) { error in
            self.setLightbulbBrightness()
        }
    }
    
    func setLightbulbBrightness() {
        if light.power?.on ?? false {
            self.lightBulb.alpha = CGFloat(light.brightness?.value ?? 0) / 100
        } else {
            self.lightBulb.alpha = 0.0
        }
    }
    
    @IBAction func brightnessTimer() {
        guard !timerButton.isSelected else {
            stopBrightnessTimer()
            return
        }
        let alert = UIAlertController(title: "Set brightness timer", message: nil, preferredStyle: .alert)
        alert.message = "Enter the desired brightness (a number between 0-100), and the number of seconds to achieve it (i.e 30)."
        alert.addTextField { (brightnessField) in
            brightnessField.placeholder = "Brightness (0 to 100)"
        }
        alert.addTextField { (timeField) in
            timeField.placeholder = "Time in seconds (i.e 30)"
        }
        let go = UIAlertAction(title: "Go", style: .default) { _ in
            self.light.brightness?.set(brightness: 0, completion: { (error) in
                if error == nil, let brightnessField = alert.textFields?[0], let timeField = alert.textFields?[1] {
                    if let brightnessText = brightnessField.text, let brightness = Int(brightnessText), let durationText = timeField.text, let duration = Double(durationText) {
                        self.light.brightness?.set(brightness: brightness, duration: duration, brightnessDelegate: self)
                        self.timerButton.isSelected = true
                    }
                }
            })
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in }
        alert.addAction(go)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func stopBrightnessTimer() {
        light.brightness?.cancelTimedBrightnessUpdate()
        timerButton.isSelected = false
    }
    
    func brightness(_ brightness: Brightness, valueDidChange newValue: Int) {
        self.brightness.value = Float(newValue)
        setLightbulbBrightness()
    }
    
    func brightness(_ brightness: Brightness, didCompleteTimedUpdate newValue: Int) {
        setLightbulbBrightness()
        timerButton.isSelected = false
    }
    
    func brightness(_ brightness: Brightness, timedUpdateFailed error: Error?) {
        let alert = UIAlertController(title: "Error updating brightness", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        timerButton.isSelected = false
    }
    
}
