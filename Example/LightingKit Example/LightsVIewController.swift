//
//  LightsVIewController.swift
//  LightingKit Example
//
//  Created by Peter Morris on 27/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit

class LightsViewController: UITableViewController {
    
    let kit: LightingKit
    let room: Room
    var dataSource: DataSource
    
    init(kit: LightingKit, room: Room, dataSource: DataSource) {
        self.kit = kit
        self.room = room
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
    
    func configureNavigationBar() {
        title = "Lights"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewLight)
        )
    }
    
    func configureTableView() {
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let light = dataSource.objects[indexPath.row] as? Light else { return }
        let lightControls = LightControlsViewController(kit: kit, light: light)
        navigationController?.pushViewController(lightControls, animated: true)
    }
    
    @objc func addNewLight() {
        let addLightController = AddNewLightViewController(kit: kit, room: room)
        let nav = UINavigationController(rootViewController: addLightController)
        addLightController.parentLightsController = self
        present(nav, animated: true, completion: nil)
    }
    
}
