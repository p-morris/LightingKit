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
    weak var parentLightsController: LightsViewController?
    private (set) var dataSource: DataSource
    
    init(kit: LightingKit, room: Room) {
        self.kit = kit
        self.room = room
        self.dataSource = DataSource(objects:[])
        self.dataSource.showLoadingIndicator = true
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        searchForNewLights()
    }
    
    func configureNavigationBar() {
        title = "Add light to \(room.name)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(close)
        )
    }
    
    func configureTableView() {
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    func searchForNewLights() {
        kit.delegate = self
        kit.searchForNewLighting()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = dataSource.objects[indexPath.row]
        
        switch object {
        case is Light: break
        case is Bridge: break
        default: break
        }
 
    }
    
    func add(light: Light, indexPath: IndexPath) {
        kit.add(light: light, toRoom: room) { success in
            if success {
                self.dataSource.objects.remove(at: indexPath.row)
                self.parentLightsController?.dataSource.objects.append(light)
                self.tableView.reloadData()
            }
        }
    }
    
    func add(bridge: Bridge, indexPath: IndexPath) {
        kit.add(bridge: bridge, toRoom: room) { success, lights in
            if success {
                self.dataSource.objects.remove(at: indexPath.row)
                if let lights = lights {
                    self.parentLightsController?.dataSource.objects.append(contentsOf: lights)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func close() {
        kit.stopNewLightingSearch()
        navigationController?.presentingViewController?.dismiss(animated: true, completion: {
            self.parentLightsController?.tableView.reloadData()
        })
    }
    
}

extension AddNewLightViewController: LightingKitDelegate {
    func add(object: LightingKitObject) {
        dataSource.objects.append(object)
        tableView.reloadData()
    }
    func lightingKit(_ lightingKit: LightingKit, foundNewLight light: Light) {
        add(object: light)
    }
    func lightingKit(_ lightingKit: LightingKit, foundNewBridge bridge: Bridge) {
        add(object: bridge)
    }
}
