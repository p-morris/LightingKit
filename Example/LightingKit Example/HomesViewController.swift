//
//  HomesViewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class HomesViewController: UITableViewController {
    
    let kit = LightingKit()
    var dataSource: DataSource<Home>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Homes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewHome))
        tableView.registerStandardCell()
        kit.permissionsDelegate = self
        kit.configureHomeKit()
    }
    
    func configureDataSource() {
        dataSource = DataSource(objects: kit.homes)
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let home = dataSource?.objects[indexPath.row] else { return }
        let rooms = kit.rooms(forHome: home)
        let roomsDataSource = DataSource<Room>(objects: rooms)
        let roomsController = RoomsViewController(kit: kit, home: home, dataSource: roomsDataSource)
        navigationController?.pushViewController(roomsController, animated: true)
    }
    
    @objc func addNewHome() {
        let alert = UIAlertController(title: "Add new home")
        alert.addObjectAction { (homeName) in
            self.kit.addHome(name: homeName) { home in
                if let home = home {
                    print("Added new home: \(home.name)")
                    self.configureDataSource()
                }
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
}

extension HomesViewController: LightingKitPermissionsDelegate {
    func lightingKit(_ lightingKit: LightingKit, permissionsGranted: Bool) {
        configureDataSource()
    }
}
