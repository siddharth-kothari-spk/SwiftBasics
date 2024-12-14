//
//  PresenterTests.swift
//  TodoItem_VIPERTests
//
//  Created by Siddharth Kothari on 14/12/24.
//

import Foundation
import XCTest
@testable import TodoItem_VIPER

class TodoPresenterTests: XCTestCase {
    var presenter: TodoPresenter!
    var view: TodoViewControllerMock!
    
    override func setUp() {
        super.setUp()
        presenter = TodoPresenter()
        view = TodoViewControllerMock()
        presenter.view = view
    }
    
    func testUpdateView() {
        let items = [TodoItem(id: 1, title: "Buy milk")]
        presenter.updateView(with: items)
        XCTAssertEqual(view.updateViewCalled, true)
    }
    
    func testAddTodoItem() {
        presenter.addTodoItem(title: "New Todo Item")
        XCTAssertEqual(view.addButtonTappedCalled, true)
    }
    
    func testToggleTodoItem() {
        let item = TodoItem(id: 1, title: "Buy milk")
        presenter.toggleTodoItem(at: 0)
        XCTAssertEqual(view.toggleTodoItemCalled, true)
    }
}
