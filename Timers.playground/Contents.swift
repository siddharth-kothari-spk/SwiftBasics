/*
 https://vikramios.medium.com/swift-timer-24149096c0db
 */

// 1. Timer Initialization:

import Foundation

class MyTimerExample {
    var timer: Timer?

    func startTimer() {
        // Create a timer that fires every 1 second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        // we create an instance of Timer using the scheduledTimer class method. This method automatically adds the timer to the current run loop, ensuring it fires at the specified interval.
        /*
         Let’s break down the parameters used in the scheduledTimer method:

             timeInterval: The time between timer firings in seconds.
             target: The object to which the selector belongs.
             selector: The method to be called when the timer fires.
             userInfo: Additional information to pass to the method specified by the selector.
             repeats: A boolean indicating whether the timer should repeatedly fire at the specified interval.
         */
    }

    @objc func timerFired() {
        print("Timer fired!")
    }
}

// Usage
let myTimerExample = MyTimerExample()
myTimerExample.startTimer()


// 2. Timer Deinitialization
// Invalidate the timer when you're done with it
myTimerExample.timer?.invalidate()
myTimerExample.timer = nil

// When you’re done with a timer, it’s essential to invalidate it to release system resources. This prevents memory leaks and ensures the timer stops firing.

