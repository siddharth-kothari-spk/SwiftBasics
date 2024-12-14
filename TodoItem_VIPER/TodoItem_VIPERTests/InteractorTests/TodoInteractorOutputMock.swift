//
//  TodoInteractorOutputMock.swift
//  TodoItem_VIPERTests
//
//  Created by Siddharth Kothari on 14/12/24.
//

import Foundation
@testable import TodoItem_VIPER

class TodoInteractorOutputMock: TodoInteractorOutput {
    var fetchTodoItemsCalled = false
    var addTodoItemCalled = false
    var toggleTodoItemCalled = false
    
    func didFetchTodoItems(_ items: [TodoItem]) {
        fetchTodoItemsCalled = true
    }
    
    func didAddTodoItem(_ item: TodoItem) {
        addTodoItemCalled = true
    }
    
    func didToggleTodoItem(_ item: TodoItem) {
        toggleTodoItemCalled = true
    }
}
