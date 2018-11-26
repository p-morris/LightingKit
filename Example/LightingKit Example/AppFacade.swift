//
//  AppFacade.swift
//  LightingKit Example
//
//  Created by Peter Morris on 26/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit
import LightingKit

class AppFacade {
    private let router: AppRouter
    private let app: UIApplication
    init(router: AppRouter = AppRouter(), app: UIApplication = UIApplication.shared) {
        self.router = router
        self.app = app
    }
    func startApp() {
        router.configure()
    }
}
