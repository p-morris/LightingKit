//
//  UIAlertController+AddObject.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(title: String) {
        self.init(title: title, message: nil, preferredStyle: .alert)
        addTextField(configurationHandler: nil)
    }
    func addObjectAction(handler: @escaping (String) -> Void) {
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            if let name = self.textFields?.first?.text, name != "" {
                handler(name)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        addAction(add)
        addAction(cancel)
    }
}
