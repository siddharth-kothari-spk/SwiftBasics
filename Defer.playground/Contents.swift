import UIKit

// defer statement is used for executing code before transferring program control outside of scope that the defer statement appears in

var value : Int = 0

func deferFunc() -> Int {
    defer {
        value += 1
    }
    return value
}

print(deferFunc()) // we get 0 here as value has not been increased yet
print(value) // we get 1 here as defer statement has increased value by 1



func deferFunc2() {
    print("A")
    defer {
        print("B")
    }
    print("C")
}

deferFunc2() // print A C B


func deferFunc3() {
    print("A1")
    defer {
        print("B1")
    }
    defer {
        print("D1")
    }
    defer {
        print("E1")
    }
    print("C1")
}

deferFunc3() // print A1 C1 E1 D1 B1


func deferFunc4() {
    print("A11")
    defer {
        print("B11")
    }
    defer {
        defer {
            print("F11")
        }
        print("D11")
    }
    defer {
        print("E11")
    }
    print("C11")
}

deferFunc4() // prints A11 C11 E11 D11 F11 B11
