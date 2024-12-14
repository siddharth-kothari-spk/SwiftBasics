//
//  Interactor.swift
//  TodoItem_VIPER
//
//  Created by Siddharth Kothari on 14/12/24.
//

import Foundation

protocol Interactor {}

protocol TodoInteractorOutput {
    func didFetchTodoItems(_ items: [TodoItem])
    func didAddTodoItem(_ item: TodoItem)
    func didToggleTodoItem(_ item: TodoItem)
}

import Foundation
class TodoInteractor: Interactor {
    var output: TodoInteractorOutput!
    var entity: TodoItem!

    func fetchTodoItems() {
        entity.fetchData { [weak self] items in
            self?.output.didFetchTodoItems(items)
        }
    }

    func addTodoItem(title: String) {
        let item = TodoItem(id: UUID().hashValue, title: title)
        entity.saveItem(item) { item in
            self.output.didAddTodoItem(item)
        }
    }

    func toggleTodoItem(item: TodoItem) {
        item.itemChecked = !item.itemChecked
        entity.saveItem(item) { item in
            self.output.didToggleTodoItem(item)
        }
    }
}
