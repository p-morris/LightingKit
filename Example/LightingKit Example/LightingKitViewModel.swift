//
//  LightingKitObjectViewModel.swift
//  LightingKit Example
//
//  Created by Peter Morris on 26/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import LightingKit

protocol ObjectViewModel {
    associatedtype ObjectType: LightingKitObject
    var router: AppRouter? { get }
    var title: String { get }
    var objects: [ObjectType] { get }
    func nextViewController(indexPath: IndexPath)
}

extension ObjectViewModel {
    func nextViewController(indexPath: IndexPath) {
        router?.pushViewController(for: objects[indexPath.row])
    }
}

struct LightingKitViewModel<T: LightingKitObject>: ObjectViewModel {
    typealias ObjectType = T
    let title: String
    weak var router: AppRouter?
    let objects: [T]
}
