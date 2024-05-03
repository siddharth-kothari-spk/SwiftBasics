//
//  ViewController.swift
//  BackgroundTaskExample
//
//  Created by Siddharth Kothari on 03/05/24.
//

// courtsey : https://www.youtube.com/watch?v=Lb7OShyNSdM&ab_channel=iOSAcademy

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // schedule background task after app launches and view has loaded
        BackgroundTask.scheduleTask()
    }


}

