// courtsey: https://levelup.gitconnected.com/phantom-types-in-swift-c6e6374386bf

import UIKit
import Foundation

/*
 What Are Phantom Types?

 Phantom Types are a type system feature in Swift, but they’re not actual types. Instead, they’re used to enforce constraints at compile-time. Phantom Types don’t introduce new runtime data but allow you to create type-safe wrappers around existing types.
 
 The core concept of a Phantom Type is to introduce a new type that holds no additional information but provides an additional type of safety.
 */

struct Celsius {
    let value: Double
}

struct Fahrenheit {
    let value: Double
}

// Now, we could accidentally mix these two types in your code, leading to hard-to-trace bugs. This is where Phantom Types come to the rescue.

/*
 Creating Phantom Types

 To implement Phantom Types, you’ll define an empty enum for each distinct type you want to represent. This enum acts as a “tag” to distinguish the types at compile-time:
 */

enum CelsiusTag {}
enum FahrenheitTag {}

struct Temperature<Unit> {
    let value: Double
}
// Here, the <Unit> in Temperature<Unit> is a generic type that acts as the phantom type.

/*
 Enforcing Type Safety

 Phantom Types excel at compile-time type checking. With our Phantom Type-based Temperature struct, you can now ensure type safety by specifying the phantom type as part of the initialization:
 */

let celsius: Temperature<CelsiusTag> = Temperature(value: 30)
let fahrenheit: Temperature<FahrenheitTag> = Temperature(value: 100)

// Attempting to mix the types will result in a compile-time error. The phantom type makes sure you use the right type in the right context.

/*
 Benefits of Phantom Types

     Type Safety: Phantom Types provide a clear and concise way to ensure type safety in your code. You eliminate runtime errors by catching type mismatches during compilation.
     Clarity: Your code becomes self-documenting. You can instantly tell the purpose and intended usage of a value by its phantom type.
     Refactoring: When you need to make changes to your codebase, phantom types help you quickly locate and update instances where a specific type is used.
     Code Maintenance: Phantom Types reduce the chances of subtle bugs creeping into your codebase, making it easier to maintain in the long run.
 */
