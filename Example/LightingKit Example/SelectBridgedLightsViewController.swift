//
//  SelectBridgedLightsViewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 30/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class SelectBridgedLightsViewController: UITableViewController {
    
    let dataSource: DataSource
    let room: Room
    let kit: LightingKit
    var completion: (([Light], [Light]) -> Void)?
    
    init(lights: [Light], room: Room, kit: LightingKit) {
        self.dataSource = DataSource(objects: lights)
        self.room = room
        self.kit = kit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureNavigationBar()
        configureTableView()
    }
    
    func configureDataSource() {
        dataSource.selectionStyle = .gray
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        title = "Add lights to \(room.name)"
    }
    
    func configureTableView() {
        tableView.allowsMultipleSelection = true
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    func selectedLights() -> [Light] {
        var lights: [Light] = []
        if let selectedIndexes = tableView.indexPathsForSelectedRows {
            for indexPath in selectedIndexes {
                if let light = dataSource.objects[indexPath.row] as? Light {
                    lights.append(light)
                }
            }
        }
        return lights
    }
    
    @objc func save() {
        guard let completion = completion else { return }
        kit.assignLights(lights: selectedLights(), toRoom: room, completion: completion)
    }
    
}
