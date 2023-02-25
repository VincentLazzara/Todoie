//
//  Category.swift
//  Todoie
//
//  Created by Vinny Lazzara on 2/23/23.
//

import Foundation
import RealmSwift

class ItemCategory: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
