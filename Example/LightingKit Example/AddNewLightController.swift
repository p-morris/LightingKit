//
//  AddNewLightController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class AddNewLightViewController: UITableViewController {
    
    let kit: LightingKit
    let room: Room
    private (set) var lights: [Light] = [] {
        didSet {
            dataSource = DataSource(objects: lights)
            tableView.dataSource = dataSource
            tableView.reloadData()
        }
    }
    private (set) var dataSource: DataSource<Light>
    
    init(kit: LightingKit, room: Room) {
        self.kit = kit
        self.room = room
        self.dataSource = DataSource<Light>(objects:lights)
        self.dataSource.showLoadingIndicator = true
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add light to \(room.name)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        tableView.registerStandardCell()
        tableView.dataSource = dataSource
        tableView.reloadData()
        kit.delegate = self
        kit.searchForNewLighting()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let light = lights[indexPath.row]
        kit.add(light: light, toRoom: room) { (success) in
            if success {
                self.lights.remove(at: indexPath.row)
            }
        }
    }
    
    @objc func close() {
        navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension AddNewLightViewController: LightingKitDelegate {
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light) {
        lights.append(light)
    }
}
