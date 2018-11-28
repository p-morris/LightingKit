//
//  RoomsViewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class RoomsViewController: UITableViewController {
    
    let kit: LightingKit
    let home: Home
    private (set) var dataSource: DataSource<Room>
    
    init(kit: LightingKit, home: Home, dataSource: DataSource<Room>) {
        self.kit = kit
        self.home = home
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rooms"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRoom))
        tableView.registerStandardCell()
        configureDataSource(home: nil)
    }
    
    func configureDataSource(home: Home?) {
        
        if let home = home {
            let rooms = kit.rooms(forHome: home)
            dataSource = DataSource(objects: rooms)
        }

        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = dataSource.objects[indexPath.row]
        let lightsSource = DataSource<Light>(objects: kit.lights(forRoom: room))
        let lightsController = LightsViewController(kit: kit, room: room, dataSource: lightsSource)
        navigationController?.pushViewController(lightsController, animated: true)
    }
    
    @objc func addNewRoom() {
        let alert = UIAlertController(title: "Add new room")
        alert.addObjectAction { (roomName) in
            self.kit.addRoom(name: roomName, toHome: self.home) { room in
                if let room = room {
                    print("Added new room: \(room.name)")
                    self.configureDataSource(home: self.home)
                }
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
}
