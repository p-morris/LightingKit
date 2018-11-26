//
//  ControllerFactory.swift
//  LightingKit Example
//
//  Created by Peter Morris on 26/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class ControllerFactory {
    func viewController<T: LightingKitObject>(for objects: [T], router: Router) -> UIViewController? {
        let model = LightingKitViewModel(objects: objects)
        return LightingKitTableViewController(viewModel: model, router: router)
    }
}
