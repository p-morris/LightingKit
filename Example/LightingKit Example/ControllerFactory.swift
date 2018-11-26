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
    func viewController<T: LightingKitObject>(for objects: [T], router: AppRouter) -> UIViewController? {
        let className = String(describing: T.self)
        let model = LightingKitViewModel(title: "\(className)s", router: router, objects: objects)
        return LightingKitTableViewController(viewModel: model)
    }
}
