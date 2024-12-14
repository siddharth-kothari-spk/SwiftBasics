//
//  TodoViewControllerMock.swift
//  TodoItem_VIPERTests
//
//  Created by Siddharth Kothari on 14/12/24.
//

import Foundation
import UIKit
@testable import TodoItem_VIPER

class TodoViewControllerMock: TodoViewController {
    var addButtonTappedCalled = false
    var updateViewCalled = false
    var toggleTodoItemCalled = false
    
    override func addButtonTapped(_ sender: UIButton) {
        addButtonTappedCalled = true
    }
    
    override func updateView(_ items: [TodoItem]) {
        updateViewCalled = true
    }
    
    override func toggleTodoItemAt(_ index: Int) {
        toggleTodoItemCalled = true
    }
}
