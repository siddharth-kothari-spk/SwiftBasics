//
//  Presenter.swift
//  TodoItem_VIPER
//
//  Created by Siddharth Kothari on 14/12/24.
//

import Foundation

protocol Presenter {}

class TodoPresenter: Presenter {
    weak var view: TodoViewController!
    var interactor: TodoInteractor!

    func updateView(with items: [TodoItem]) {
        view.todoItems = items
    }

    func addTodoItem(title: String) {
        interactor.addTodoItem(title: title)
    }

    func toggleTodoItem(at index: Int) {
        interactor.toggleTodoItem(item: view.todoItems[index])
    }
}
