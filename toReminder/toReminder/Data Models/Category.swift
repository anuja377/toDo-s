//
//  Category.swift
//  toReminder
//
//  Created by Gaurav Gaikwad on 8/12/19.
//  Copyright © 2019 anuja. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let item = List<Item>()
}
