//
//  Item.swift
//  Todoie
//
//  Created by Vinny Lazzara on 2/23/23.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: ItemCategory.self, property: "items")
}
