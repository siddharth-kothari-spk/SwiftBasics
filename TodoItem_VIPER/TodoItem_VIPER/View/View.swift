//
//  View.swift
//  TodoItem_VIPER
//
//  Created by Siddharth Kothari on 14/12/24.
//

import Foundation
import UIKit

class TodoViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var presenter: TodoPresenter!

    var todoItems: [TodoItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.interactor = TodoInteractor()
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        presenter.addTodoItem(title: "New Todo Item")
    }
}
