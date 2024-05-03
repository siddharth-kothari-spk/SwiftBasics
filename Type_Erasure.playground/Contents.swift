// https://antran.app/2024/swift_type_erasure/

/*
 When working with protocols and generics in Swift, you may encounter situations where you need to hide the specific type information of an object and provide a more generic interface. This is where type erasure comes into play
 
 Type erasure is a powerful technique in Swift that allows you to conceal the specific type information of an object, presenting a more generic interface to the outside world.
 
 In Swift, type erasure is typically achieved using the Any or AnyObject types.

     Any can hold a reference to any type
     AnyObject can hold a reference to any class type.

 By utilizing these types, you can erase the specific type information and interact with objects through a generic interface.

 Another technique to erase types is to create a concrete wrapper type (such as AnyPublisher), which hide away the details of the generic types.
 */

import Foundation


protocol AnimalSound {
    func play()
}

struct DefaultDogSound: AnimalSound {
    func play() {
        print("Woof!")
    }
}

struct DefaultCatSound: AnimalSound {
    func play() {
        print("Meow!")
    }
}

protocol Animal {
    associatedtype Sound
    var name: String { get }
    func makeSound() -> Sound
}

// concrete implementations
class Dog: Animal {
    var name: String

    init(name: String) {
        self.name = name
    }

    func makeSound() -> AnimalSound {
        DefaultDogSound()
    }
}

class Cat: Animal {
    var name: String

    init(name: String) {
        self.name = name
    }

    func makeSound() -> AnimalSound {
        DefaultCatSound()
    }
}


/*
 Now, let’s say we want to work with a collection of animals without exposing their specific types. This is where type erasure comes in handy. We can create a type eraser struct called AnyAnimal that conforms to the Animal protocol
 */

struct AnyAnimal: Animal {
    private let _name: () -> String
    private let _makeSound: () -> AnimalSound

    init<T: Animal>(_ animal: T) where T.Sound == AnimalSound {
        _name = { animal.name }
        _makeSound = { animal.makeSound() }
    }

    var name: String {
        return _name()
    }

    func makeSound() -> AnimalSound {
        _makeSound()
    }
}

/*
 Inside AnyAnimal, we have private properties _name and _makeSound of function types that capture the name and makeSound() implementations of the underlying animal. The init method takes a generic parameter T that conforms to the Animal protocol and initializes the private properties with the corresponding implementations.
 */

let dog = Dog(name: "Buddy")
let cat = Cat(name: "Whiskers")

let animals: [AnyAnimal] = [AnyAnimal(dog), AnyAnimal(cat)]

for animal in animals {
    print("\(animal.name) says:")
    let sound = animal.makeSound()
    sound.play()
}
