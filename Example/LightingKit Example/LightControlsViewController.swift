//
//  LightControlsViewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class LightControlsViewController: UIViewController {
    
    enum AlertString {
        static let timerTitle = "Set brightness timer"
        static let timerMessage = "Enter the desired brightness (a number between 0-100), and the number of seconds to achieve it (i.e 30)."
        static let brightnessPlaceholder = "Brightness (0 to 100)"
        static let durationPlaceholder = "Duration in seconds (i.e 30)"
        
    }
    
    let kit: LightingKit
    let light: Light
    @IBOutlet var powerSwitch: UISwitch!
    @IBOutlet var brightnessSlider: UISlider!
    @IBOutlet var lightImageView: UIImageView!
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
        configureNavigationBar()
        configureView()
        setLightImageViewBrightness()
    }
    
    func configureNavigationBar() {
        title = light.name.capitalized
    }
    
    func configureView() {
        lightImageView.image = lightImageView.image?.withRenderingMode(.alwaysTemplate)
        lightImageView.tintColor = UIColor.yellow
        powerSwitch.isOn = light.power?.isOn ?? false
        brightnessSlider.setValue(Float(light.brightness?.value ?? 0), animated: false)
    }
    
    @IBAction func setPower() {
        light.power?.on(powerSwitch.isOn) { error in
            self.setLightImageViewBrightness()
        }
    }
    
    @IBAction func brightnessSliderValueChanged() {
        let brightnessValue = Int(roundf(brightnessSlider.value))
        light.brightness?.set(brightness: brightnessValue) { error in
            self.setLightImageViewBrightness()
        }
    }
    
    func setLightImageViewBrightness() {
        if light.power?.isOn ?? false {
            self.lightImageView.alpha = CGFloat(light.brightness?.value ?? 0) / 100
        } else {
            self.lightImageView.alpha = 0.0
        }
    }
    
    @IBAction func brightnessTimer() {
        guard !timerButton.isSelected else {
            stopBrightnessTimer()
            return
        }
        
        let alert = UIAlertController(
            title: AlertString.timerTitle,
            message: AlertString.timerMessage,
            preferredStyle: .alert
        )
        alert.addTextField { (brightnessField) in
            brightnessField.placeholder = AlertString.brightnessPlaceholder
        }
        alert.addTextField { (timeField) in
            timeField.placeholder = AlertString.durationPlaceholder
        }
        alert.addAction(
            UIAlertAction(title: "Go", style: .default) { _ in
                if let brightness = alert.textFields?[0].intFromText(),
                    let duration = alert.textFields?[1].timeIntervalFromText() {
                    self.setTimer(desiredBrightness: brightness, duration: duration)
                }
            }
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .destructive) { _ in }
        )
        present(alert, animated: true, completion: nil)
    }
    
    func setTimer(desiredBrightness: Int, duration: TimeInterval) {
        guard let brightness = light.brightness else { return }
        brightness.set(brightness: 0) { error in
            guard error == nil else {
                self.brightness(brightness, timedUpdateFailed: error)
                return
            }
            brightness.set(brightness: desiredBrightness, duration: duration, brightnessDelegate: self)
            self.timerButton.isSelected = true
        }
    }
    
    func stopBrightnessTimer() {
        light.brightness?.cancelTimedBrightnessUpdate()
        timerButton.isSelected = false
    }
    
}

extension LightControlsViewController: TimedBrightnessUpdateDelegate {
    
    func brightness(_ brightness: Brightness, valueDidChange newValue: Int) {
        self.brightnessSlider.value = Float(newValue)
        setLightImageViewBrightness()
    }
    
    func brightness(_ brightness: Brightness, didCompleteTimedUpdate newValue: Int) {
        setLightImageViewBrightness()
        timerButton.isSelected = false
    }
    
    func brightness(_ brightness: Brightness, timedUpdateFailed error: Error?) {
        let alert = UIAlertController(title: "Error updating brightness", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        timerButton.isSelected = false
    }
    
}
