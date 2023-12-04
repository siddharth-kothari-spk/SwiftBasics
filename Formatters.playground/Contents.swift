// https://www.swiftwithvincent.com/
import Foundation

// DateComponentsFormatter
//1. https://developer.apple.com/documentation/foundation/datecomponentsformatter

let formatter = DateComponentsFormatter()
formatter.unitsStyle = .full
formatter.includesApproximationPhrase = true
formatter.includesTimeRemainingPhrase = true
formatter.allowedUnits = [.minute]
 
// Use the configured formatter to generate the string.
let outputString = formatter.string(from: 300.0) // About 5 minutes remaining

