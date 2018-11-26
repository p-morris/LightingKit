//
//  LightingKitObjectViewModel.swift
//  LightingKit Example
//
//  Created by Peter Morris on 26/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import LightingKit

protocol ObjectViewModel: class {
    associatedtype ObjectType: LightingKitObject
    var title: String { get }
    var selectionStyle: UITableViewCell.SelectionStyle { get }
    var objects: [ObjectType] { get }
}

class LightingKitViewModel<T: LightingKitObject>: ObjectViewModel {
    typealias ObjectType = T
    var title: String {
        return "\(String(describing: T.self))s"
    }
    var selectionStyle: UITableViewCell.SelectionStyle {
        return .none
    }
    let objects: [T]
    init(objects: [T]) {
        self.objects = objects
    }
}
