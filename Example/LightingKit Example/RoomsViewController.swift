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
    var dataSource: DataSource
    
    init(kit: LightingKit, home: Home, dataSource: DataSource) {
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
        configureNavigationBar()
        configureTableView()
    }
    func configureTableView() {
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    func configureNavigationBar() {
        title = "Rooms"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewRoom)
        )
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let room = dataSource.objects[indexPath.row] as? Room else { return }
        let lightsSource = DataSource(objects: kit.lights(forRoom: room))
        let lightsController = LightsViewController(kit: kit, room: room, dataSource: lightsSource)
        navigationController?.pushViewController(lightsController, animated: true)
    }
    @objc func addNewRoom() {
        let alert = UIAlertController(title: "Add new room")
        alert.addObjectAction { (roomName) in
            self.kit.addRoom(name: roomName, toHome: self.home) { room in
                if let room = room {
                    self.dataSource.objects.append(room)
                    self.tableView.reloadData()
                }
            }
        }
        present(alert, animated: true, completion: nil)
    }
}
