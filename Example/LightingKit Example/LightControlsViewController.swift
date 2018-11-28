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
    
    let kit: LightingKit
    let light: Light
    
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
    }
    
}
