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

if let resultRegexLiteral = try? regexLiteral.wholeMatch(in: wifi) {
    print("SSID: \(resultRegexLiteral.ssid)")
    print("Security: \(String(describing: resultRegexLiteral.security))")
    print("Password: \(resultRegexLiteral.password)")
}

// Option 2: The RegexBuilder APIs allow you to compose a regular expression using a set of result builders that make the code a lot more readable and maintainable.

import RegexBuilder

let ssid = Reference(Substring.self)
let password = Reference(Substring.self)
let security = Reference(Substring.self)
let hidden = Reference(Substring.self)

let regexBuilder = Regex {
    "WIFI:S:"
    Capture(as: ssid) {
        OneOrMore(CharacterClass.anyOf(";").inverted)
    }
    ";"
    Optionally {
        Regex {
            "T:"
            Capture(as: security) {
                ZeroOrMore(CharacterClass.anyOf(";").inverted)
            }
            ";"
        }
    }
    "P:"
    Capture(as: password) {
        OneOrMore(CharacterClass.anyOf(";").inverted)
    }
    ";"
    Optionally {
        Regex {
            "H:"
            Capture(as: hidden) {
                ZeroOrMore(CharacterClass.anyOf(";").inverted)
            }
            ";"
        }
    }
    ";"
}
    .anchorsMatchLineEndings()

if let resultRegexBuilder = try? regexBuilder.wholeMatch(in: wifi) {
    print("SSID: \(resultRegexBuilder[ssid])")
    print("Security: \(resultRegexBuilder[security])")
    print("Password: \(resultRegexBuilder[password])")
}


// Option 3: Using NSRegularExpression

//NSRegularExpression is an alternative API you can use if you still need to support versions older than iOS 16.

//let pattern = "WIFI:S:(?<ssid>[^;]+);(?:T:(?<security>[^;]*);)?P:(?<password>[^;]+);(?:H:(?<hidden>[^;]*);)?;"

let regexNSRegularExpression = try! NSRegularExpression(
    pattern: #"WIFI:S:(?<ssid>[^;]+);(?:T:(?<security>[^;]*);)?P:(?<password>[^;]+);(?:H:(?<hidden>[^;]*);)?;"#,
    options: []
)

let range = NSRange(wifi.startIndex..<wifi.endIndex, in: wifi)

guard let match = regexNSRegularExpression.firstMatch(in: wifi, options: [], range: range) else {
        print("no match found")
        fatalError()
}

if let ssidRange = Range(match.range(withName: "ssid"),in: wifi),
   let passwordRange = Range(match.range(withName: "password"), in: wifi) {
    
    let security: String? = {
        guard let range = Range(match.range(withName: "security"), in: wifi) else {
            return nil
        }
        return String(wifi[range])
    }()
    
    
    let hidden: String? = {
        guard let range = Range(match.range(withName: "hidden"), in: wifi) else {
            return nil
        }
        return String(wifi[range])
    }()
    
    print("SSID: \(wifi[ssidRange])")
        print("Password: \(wifi[passwordRange])")
        print("Security: \(security ?? "not set")")
        print("Hidden: \(hidden ?? "not set")")
}
        
