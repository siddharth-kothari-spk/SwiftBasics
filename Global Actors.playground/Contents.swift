// https://stevenpcurtis.medium.com/global-actors-in-swift-concurrency-4945f5b1512b

/*
 @MainActor: is a Swift attribute used to indicate that a type or function must be executed on the main thread.

 Global Actors: Singleton actors which can be used to provide synchronization and ensure correct data access in concurrent contexts

 Singleton: A way of instantiation that guarantees that only one instance of a class is created
 */

@globalActor
struct CustomGlobalActor {
  actor ActorType { }

  static let shared: ActorType = ActorType()
}

class MyClass {
    @MainActor
    var uiProperty: String = "Hello, UI!"

    @CustomGlobalActor
    var customProperty: String = "Hello, Custom!"

    @MainActor
    func updateUIProperty(value: String) {
        uiProperty = value
    }

    @CustomGlobalActor
    func updateCustomProperty(value: String) {
        customProperty = value
    }
}

let myClass = MyClass()
await print(myClass.customProperty)
