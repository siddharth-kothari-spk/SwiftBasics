//
//  UserTextInput.swift
//  Property_Wrapper
//
//  Created by Siddharth Kothari on 11/04/24.
//

import Foundation

@propertyWrapper
struct UserInputText {
    private var input = ""
    var wrappedValue: String {
        get { return input }
        set { input = String(newValue.prefix(10)) }
    }
}

@UserInputText var message: String = "abcdefghij"
print(message)

message = "abcdefghij-abcdefghij"
print(message)
