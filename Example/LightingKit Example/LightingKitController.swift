//
//  LightingKitController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import LightingKit

class LightingKitController<T: LightingKitObject, P: LightingKitObject>: UITableViewController {
    var parentObject: P?
    var dataSource: DataSource<T>? {
        didSet {
            tableView.reloadData()
        }
    }
    let routes: Routes?
    init(dataSource: DataSource<T>, routes: Routes, parentObject: P? = nil) {
        self.dataSource = dataSource
        self.routes = routes
        self.parentObject = parentObject
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        dataSource = nil
        routes = nil
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureNavigationItem()
    }
    func configureDataSource() {
        tableView.registerStandardCell()
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    func configureNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addObject))
    }
    @objc func addObject() {
        routes?.route(from: parentObject, presentOn: self)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selected = dataSource?.objects[indexPath.row] else { return }
        routes?.route(from: selected, pushOn: navigationController)
    }
}
