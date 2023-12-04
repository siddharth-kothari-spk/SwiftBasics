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

// 3. MeasurementFormatter
// https://developer.apple.com/documentation/foundation/measurementformatter

let distanceInKiloMeters = 1.2

// Distance is 1.2 km
print("Distance is \(distanceInKiloMeters) km")

let measurement = Measurement(
    value: distanceInKiloMeters,
    unit: UnitLength.kilometers
)

let measurementFormatter = MeasurementFormatter()

measurementFormatter.locale = Locale(identifier: "en_US")

// Distance is 0.746 mi
print("Distance is \(measurementFormatter.string(from: measurement))")


// 4. ByteCountFormatter
// https://developer.apple.com/documentation/foundation/bytecountformatter

let byteCountFormatter = ByteCountFormatter()
byteCountFormatter.countStyle = .file

print("\(byteCountFormatter.string(fromByteCount: 1_000_000_000))")
