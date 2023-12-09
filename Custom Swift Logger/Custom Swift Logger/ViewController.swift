//
//  ViewController.swift
//  Custom Swift Logger
//
//  Created by Siddharth Kothari on 09/12/23.
//

// courtsey: https://medium.com/@alessandromanilii/custom-swift-logger-in-xcode15-19da40a058a5

import UIKit

class ViewController: UIViewController {

    var response: String = """
    {
      "id": 1,
      "title": "iPhone 9",
      "description": "An apple mobile which is nothing like apple",
      "price": 549,
      "discountPercentage": 12.96,
      "rating": 4.69,
      "stock": 94,
      "brand": "Apple",
      "category": "smartphones",
      "thumbnail": "https://i.dummyjson.com/data/products/1/thumbnail.jpg",
      "images": [
        "https://i.dummyjson.com/data/products/1/1.jpg",
        "https://i.dummyjson.com/data/products/1/2.jpg",
        "https://i.dummyjson.com/data/products/1/3.jpg",
        "https://i.dummyjson.com/data/products/1/4.jpg",
        "https://i.dummyjson.com/data/products/1/thumbnail.jpg"
      ]
    }
"""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AppLogger.log(tag: .success, "viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppLogger.log(tag: .warning, "viewWillAppear")
        AppLogger.log(tag: .error, "error")
        AppLogger.log(tag: .debug, "debug")
        AppLogger.log(tag: .network, response)
        AppLogger.log(tag: .simOnly, "simulator")
        AppLogger.log(tag: .success, "success")
    }


}

