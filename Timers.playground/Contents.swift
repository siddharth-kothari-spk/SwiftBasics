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



// 3. Timer Tolerance

//Timer tolerance allows you to control the flexibility of the timer’s firing schedule. By setting a tolerance, you indicate how much variability is acceptable in the firing time. This can be particularly useful for power optimization, as the system can optimize timer firing to conserve energy.

class ToleranceExample {
    var timer: Timer?

    func startTimer() {
        // Create a timer with a time interval of 1 second and a tolerance of 0.1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)

        // Set the timer tolerance
        timer?.tolerance = 0.1
    }

    @objc func timerFired() {
        print("Timer fired!")
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}

// Usage
let toleranceExample = ToleranceExample()
toleranceExample.startTimer()




// 4. Debouncing with Timer

//Debouncing is a technique used to ensure that time-consuming tasks, such as network requests or UI updates, are only executed once after a series of rapid calls. This is often used in scenarios like search bars, where you want to wait for the user to finish typing before triggering a search.

import Foundation

class DebounceExample {
    var timer: Timer?
    let debounceInterval = 0.5 // Set your desired debounce interval

    func userDidType() {
        // Invalidate the previous timer (if any) to restart the debounce interval
        timer?.invalidate()

        // Start a new timer for the debounce interval
        timer = Timer.scheduledTimer(timeInterval: debounceInterval, target: self, selector: #selector(search), userInfo: nil, repeats: false)
    }

    @objc func search() {
        // Perform the actual search or time-consuming task here
        print("Performing search...")
    }
}

// Usage
let debounceExample = DebounceExample()

// Simulate user typing by calling userDidType multiple times quickly
debounceExample.userDidType()
debounceExample.userDidType()
debounceExample.userDidType()

// Real-world Example: Search Bar Debouncing

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!

    var timer: Timer?
    let debounceInterval = 0.5 // Set your desired debounce interval

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Invalidate the previous timer (if any) to restart the debounce interval
        timer?.invalidate()

        // Start a new timer for the debounce interval
        timer = Timer.scheduledTimer(timeInterval: debounceInterval, target: self, selector: #selector(performSearch), userInfo: searchText, repeats: false)
    }

    @objc func performSearch(timer: Timer) {
        guard let searchText = timer.userInfo as? String else {
            return
        }

        // Perform the actual search operation with the searchText
        print("Searching for: \(searchText)")
    }
}


// 5. Practical Examples

// Updating UI Periodically

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!

    var timer: Timer?
    var secondsElapsed = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }

    @objc func updateTimerLabel() {
        secondsElapsed += 1
        timerLabel.text = "Seconds Elapsed: \(secondsElapsed)"
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}
