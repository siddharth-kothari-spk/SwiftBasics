// https://www.swiftwithvincent.com/
import Foundation

// 1. DateComponentsFormatter
// https://developer.apple.com/documentation/foundation/datecomponentsformatter

let dateComponentsFormatter = DateComponentsFormatter()
dateComponentsFormatter.unitsStyle = .full
dateComponentsFormatter.includesApproximationPhrase = true
dateComponentsFormatter.includesTimeRemainingPhrase = true
dateComponentsFormatter.allowedUnits = [.minute]
 
// Use the configured formatter to generate the string.
let outputStringDateComponentsFormatter = dateComponentsFormatter.string(from: 300.0) // About 5 minutes remaining


// 2. DateIntervalFormatter
// https://developer.apple.com/documentation/foundation/dateintervalformatter

let dateIntervalFormatter = DateIntervalFormatter()
dateIntervalFormatter.dateStyle = .short
dateIntervalFormatter.timeStyle = .none


// Create two dates that are exactly 1 day apart.
let startDate = Date()
let endDate = Date(timeInterval: 86400, since: startDate)


// Use the configured formatter to generate the string.
let outputStringDateIntervalFormatter = dateIntervalFormatter.string(from: startDate, to: endDate)
