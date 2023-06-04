import UIKit

/*
 Method overload vs override,
 both concepts refer to a different flavor of polymorphism.

 And polymorphism is about how a same symbol can represent multiple different things, depending on the context in which it is used.
 
 We overload a method when we define one or more methods with the same name, but with a different combination of arguments.
 
 */
//---------------------------------------
// OVERLOAD
/*
 In Swift, overloading can happen in two different ways.

 It can happen either by explicitly defining a new implementation of a method for each combination of arguments, like
 
 */

func handle(value: Int) {
    /* ... */
}

func handle(value: Double) {
    /* ... */
}

/*
 
 The compiler will then take care of calling the correct method, depending on the type of the argument used at the call site 👌

 But overloading can also be achieved by using a generic argument (also known as parametrized type).

 In that case, the compiler will take care of creating overloads that match each call site.

 */

func handle<T: Numeric>(value: T) {
    /* ... */
}

/*
 It's important to note that this form of polymorphism doesn't depend on runtime conditions, and so can be entirely handled at compile time.

 This is important because it means that the compiler is able to optimize the code so that there's little-to-no overhead at runtime.
 */


//---------------------------------------------
// OVERRIDE
/*
Once again, the idea is for a same method to have a different behavior, depending on the context in which it is called.

But this time the behavior won't depend on the arguments passed to the method but rather on the actual type of the object the method is called upon.

In Swift, method overriding is only possible when using classes.
*/

class A {
    func method() {
        print("class A implementation")
    }
}

class B: A {
    override func method() {
        print("class B implementation")
    }
}

// When we call the method, the implementation that will be used will depend on the actual type of the instance at runtime.

let instance: A = B()

instance.method() // "class B implementation"

// Unlike overloading, overriding does have a cost at runtime, because the compiler won't be able to prematurely decide on the right method to call, since it can depend on state that won't be known until runtime:

let instance = Bool.random() ? A() : B()

instance.method()


// - overloading is about providing different method implementations depending on the argument types used at compile time

// - overriding is about the same thing, but this time depending on the instance type used at runtime


//--------------------
// EXTRA

/*
 As Swift supports sub-typing, it's totally possible for a call site to have more than one potential method overload candidate that matches the types being used.

 In order to decide which candidate overload should be used, Swift relies on a set of rules.

 For instance, Swift will always prefer an overload with a matching concrete type over one with a matching generic type.

 Here's how such a situation would look like:
 */

func handleValue(value: Int) {
    print("non-generic overload")
}

func handleValue<T: Numeric>(value: T) {
    print("generic overload")
}

let int: Int = 3

// calls the non-generic overload
handleValue(value: int)
