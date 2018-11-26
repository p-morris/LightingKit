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
    let router: Router?
    
    init(viewModel: LightingKitViewModel<T>, router: Router) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = LightingKitViewModel<T>(objects: [])
        router = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addObject))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.reloadData()
    }
    
    var textField: UITextField?
    
    @objc func addObject() {
        let object: T? = nil
        router?.route(from: self, with: object)
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
        cell.selectionStyle = viewModel.selectionStyle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.route(from: self, with: viewModel.objects[indexPath.row])
    }
    
}
