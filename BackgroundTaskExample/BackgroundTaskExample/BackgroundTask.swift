//
//  BackgroundTask.swift
//  BackgroundTaskExample
//
//  Created by Siddharth Kothari on 03/05/24.
//

import Foundation
import BackgroundTasks

class BackgroundTask {
    
    public static let taskID = "com.siddharthkothari.BackgroundTaskExample.BG_Task"
    public static func registerBackgroundTask() {
        // register task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskID, using: nil) { task in
            // handle task
        }
        // schedule task
    }
}
