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
    init(objects: [T]) {
        self.objects = objects
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueStandardCell() else {
            fatalError("Failed to dequeue standard cell")
        }
        cell.textLabel?.text = objects[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
}
