import SwiftUI
// 1. What does the some keyword do in the  Swift code

func test1(function: some View) {
    
}
// Swift allows us to use the some keyword when referencing protocols with associated types as parameters.

// we can write above func as

func test1Modified<T: View>(function: T) {
    
}
