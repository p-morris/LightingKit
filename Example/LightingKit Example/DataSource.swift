//
//  DataSource.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import LightingKit

class DataSource<T: LightingKitObject>: NSObject, UITableViewDataSource {
    
    let objects: [T]
    var showLoadingIndicator = false
    
    init(objects: [T]) {
        self.objects = objects
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count == 0 && showLoadingIndicator ? 1 : objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueStandardCell() else {
            fatalError("Failed to dequeue standard cell")
        }
        if objects.count == 0 {
            cell.textLabel?.text = "Searching for new lights..."
            let indicator = UIActivityIndicatorView(style: .gray)
            indicator.startAnimating()
            cell.accessoryView = indicator
            return cell
        } else {
            cell.accessoryView = nil
            cell.textLabel?.text = objects[indexPath.row].name
            cell.selectionStyle = .none
            return cell
        }
    }
    
}
