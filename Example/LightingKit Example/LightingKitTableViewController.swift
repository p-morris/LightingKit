//
//  LightingKitTableViewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 26/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class LightingKitTableViewController<T: LightingKitObject>: UITableViewController {
    
    let reuseID = "cell"
    let viewModel: LightingKitViewModel<T>
    
    init(viewModel: LightingKitViewModel<T>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = LightingKitViewModel<T>(title: "", router: nil, objects: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        title = viewModel.title
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) else {
            fatalError("Unable to dequeue \(reuseID) tableviewcell.")
        }
        cell.textLabel?.text = viewModel.objects[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.nextViewController(indexPath: indexPath)
    }
    
}
