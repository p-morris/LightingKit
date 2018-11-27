//
//  UITableView+StandardCell.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit

extension UITableView {
    var reuseID: String {
        return "cell"
    }
    func registerStandardCell(_ type: AnyClass? = UITableViewCell.self) {
        register(type, forCellReuseIdentifier: reuseID)
    }
    func dequeueStandardCell() -> UITableViewCell? {
        return dequeueReusableCell(withIdentifier: reuseID)
    }
}
