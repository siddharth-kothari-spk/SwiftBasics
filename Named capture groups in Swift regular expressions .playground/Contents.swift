// https://www.polpiella.dev/named-capture-groups-in-swift-regular-expressions/

/*
 ExampleWifiURL
 
 WIFI:S:wifinetwork;T:WPA;P:password;;
 
 The URL above defines the required information to join the WIFI network through a number of key-value pairs:

     S: The SSID of the WIFI network. This is a required field.
     T: The type of security used by the WIFI network. This is an optional field. It can be one of the following values: WEP, WPA, WPA2, or nopass.
     P: The password of the WIFI network. This is a required field. If the WIFI network does not require a password, this field should be empty.
     H: The hidden status of the WIFI network. This is an optional field. If not specified, the WIFI network is assumed to be a visible network and the H field will be empty or FALSE.
 */

// WifiRegex
// WIFI:S:(?<ssid>[^;]+);(?:T:(?<security>[^;]*);)?P:(?<password>[^;]+);(?:H:(?<hidden>[^;]*);)?;

// SwiftRegex is a relatively new API introduced in iOS 16 that allows you to write and use regular expressions in a more Swift-friendly way.

// Option 1 : Using Regex literals

import Foundation
let wifi = "WIFI:S:superwificonnection;T:WPA;P:strongpassword;;"
// You can define a Regex literal by wrapping a regular expression in forward slashes

let regexLiteral = /WIFI:S:(?<ssid>[^;]+);(?:T:(?<security>[^;]*);)?P:(?<password>[^;]+);(?:H:(?<hidden>[^;]*);)?;/

if let result = try? regexLiteral.wholeMatch(in: wifi) {
    print("SSID: \(result.ssid)")
    print("Security: \(String(describing: result.security))")
    print("Password: \(result.password)")
}
