//
//  BackgroundTask.swift
//  BackgroundTaskExample
//
//  Created by Siddharth Kothari on 03/05/24.
//

import Foundation
import BackgroundTasks

class BackgroundTask {
    
    public static func registerBackgroundTask() {
        // register task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "", using: nil) { task in
            // handle task
        }
        // schedule task
    }
}
