//
//  InteractorTests.swift
//  TodoItem_VIPERTests
//
//  Created by Siddharth Kothari on 14/12/24.
//

import XCTest
@testable import TodoItem_VIPER

class TodoInteractorTests: XCTestCase {
    var interactor: TodoInteractor!
    var output: TodoInteractorOutputMock!
    
    override func setUp() {
        super.setUp()
        interactor = TodoInteractor()
        output = TodoInteractorOutputMock()
        interactor.output = output
    }
    
    func testFetchTodoItems() {
        interactor.fetchTodoItems()
        XCTAssertEqual(output.fetchTodoItemsCalled, true)
    }
    
    func testAddTodoItem() {
        interactor.addTodoItem(title: "New Todo Item")
        XCTAssertEqual(output.addTodoItemCalled, true)
    }
    
    func testToggleTodoItem() {
        let item = TodoItem(id: 1, title: "Buy vegetables")
        interactor.toggleTodoItem(item: item)
        XCTAssertEqual(output.toggleTodoItemCalled, true)
    }
}
