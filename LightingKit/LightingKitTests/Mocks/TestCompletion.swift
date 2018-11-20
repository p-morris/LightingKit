//
//  TestCompletion.swift
//  LightingKitTests
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation

class TestCompletion {
    var complete = false
    func getCompletion() -> ((Bool) -> Void) {
        return { (completed: Bool) in
            self.complete = completed
        }
    }
}
