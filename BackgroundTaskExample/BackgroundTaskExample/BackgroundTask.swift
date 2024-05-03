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
            guard let task = task as? BGAppRefreshTask else { return }
            handleTask(task)
        }
        // schedule task
    }
    
    private static func handleTask(_ task: BGAppRefreshTask) {
        
    }
    
    private static func scheduleTask() {
        do {
            let taskRequest = BGAppRefreshTaskRequest(identifier: taskID)
            
            /*!
             @abstract The earliest date at which the task may run.
             @discussion Setting this property does not guarantee that the task will begin at the specified date, but only that it will not begin sooner. If not specified, no start delay is used.
             */
            taskRequest.earliestBeginDate = Date().addingTimeInterval(86400 * 3)
            
            try BGTaskScheduler.shared.submit(taskRequest)
        } catch {
            
        }
        
    }
}
