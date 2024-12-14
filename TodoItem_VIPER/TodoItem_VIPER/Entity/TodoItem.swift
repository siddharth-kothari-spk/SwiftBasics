//
//  TodoItem.swift
//  TodoItem_VIPER
//
//  Created by Siddharth Kothari on 14/12/24.
//

import Foundation

protocol Entity {}

import Foundation

class TodoItem: Entity {
    var id: Int
    var title: String
    var itemChecked: Bool

    init(id: Int, title: String, itemChecked: Bool = false) {
        self.id = id
        self.title = title
        self.itemChecked = itemChecked
    }

    func fetchData(completion: @escaping ([TodoItem]) -> Void) {
    // Fetch data from storage or API
    let items = [
            TodoItem(id: 1, title: "Buy vegetables"),
            TodoItem(id: 2, title: "Water the plants"),
            TodoItem(id: 3, title: "Laundry")
        ]
     completion(items)
    }
}
