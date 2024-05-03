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
    }
    
    private static func handleTask(_ task: BGAppRefreshTask) {
        let count = UserDefaults.standard.integer(forKey: "task_run_count")
        UserDefaults.setValue(count + 1, forKey: "task_run_count")
        
        task.expirationHandler = {
            // cancel all background work
        }
    }
    
    public static func scheduleTask() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskID)
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            print("\(requests.count) BG tasks pending")
            
            guard requests.isEmpty else { return }
            
            do {
                let taskRequest = BGAppRefreshTaskRequest(identifier: taskID)
                
                /*!
                 @abstract The earliest date at which the task may run.
                 @discussion Setting this property does not guarantee that the task will begin at the specified date, but only that it will not begin sooner. If not specified, no start delay is used.
                 */
                taskRequest.earliestBeginDate = Date().addingTimeInterval(86400 * 3)
                
                try BGTaskScheduler.shared.submit(taskRequest)
                print("Task scheduled")
            } catch (let taskError) {
                print("Failed to schedule : \(taskError)")
            }
        }
        
        
        
    }
}
