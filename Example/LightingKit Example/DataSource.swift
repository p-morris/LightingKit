//
//  DataSource.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import LightingKit

class DataSource: NSObject, UITableViewDataSource {
    
    var objects: [LightingKitObject]
    var selectionStyle: UITableViewCell.SelectionStyle = .none
    var showLoadingIndicator = false
    
    init(objects: [LightingKitObject]) {
        self.objects = objects
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count == 0 && showLoadingIndicator ? 1 : objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        return objects.count > 0 ?
               configure(cell: cell, withObject: objects[indexPath.row]) :
               configureAsLoadingIndicator(cell: cell)
        
    }
    
    func configureAsLoadingIndicator(cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.text = "Searching for new lights..."
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.startAnimating()
        cell.accessoryView = indicator
        return cell
    }
    
    func configure(cell: UITableViewCell, withObject object: LightingKitObject) -> UITableViewCell {
        cell.accessoryView = nil
        cell.textLabel?.text = object.name + (object is Bridge ? " (Bridge)" : "")
        cell.selectionStyle = selectionStyle
        return cell
    }
    
}
