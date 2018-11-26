//
//  UIKitExtensions.swift
//  LightingKit Example
//
//  Created by Peter Morris on 26/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit

extension UINavigationController {
    func pushViewControllerAnimated(_ controller: UIViewController?) {
        guard let controller = controller else { return }
        pushViewController(controller, animated: true)
    }
}
