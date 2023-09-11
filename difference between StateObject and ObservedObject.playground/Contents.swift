// https://www.donnywals.com/whats-the-difference-between-stateobject-and-observedobject/
import SwiftUI

// Views in SwiftUI are thrown away and recreated regularly. When this happens, the entire view struct is initialized all over again. Because of this, any values that you create in a SwiftUI view are reset to their default values unless you've marked these values using @State.

// This means that if you declare a view that creates its own @ObservedObject instance, that instance is replaced every time SwiftUI decides that it needs to discard and redraw that view.

class DataSource: ObservableObject {
  @Published var counter = 0
}

struct Counter: View {
  @ObservedObject var dataSource = DataSource()

  var body: some View {
    VStack {
      Button("Increment counter") {
        dataSource.counter += 1
      }

      Text("Count is \(dataSource.counter)")
    }
  }
}

struct ItemList: View {
  @State private var items = ["hello", "world"]

  var body: some View {
    VStack {
      Button("Append item to list") {
        items.append("test")
      }

      List(items, id: \.self) { name in
        Text(name)
      }

      Counter()
    }
  }
}

// If you'd tap the Increment counter button defined in Counter a couple of times, you'd see that its Count is ... label updates everytime. If you then tap the Append item to list button that's defined in ItemList, the Count is ... label in Counter resets back to 0. The reason for this is that Counter got recreated which means that we now have a fresh instance of DataSource.

// To fix this, we could either create the DataSource in ItemList, keep that instance around as a property on ItemList and pass that instance to Counter, or we can use @StateObject instead of @ObservedObject:

struct CounterStateObject: View {
  @StateObject var dataSource = DataSource()

  var body: some View {
    VStack {
      Button("Increment counter") {
        dataSource.counter += 1
      }

      Text("Count is \(dataSource.counter)")
    }
  }
}

// By making DataSource a @StateObject, the instance we create is kept around and used whenever the Counter view is recreated. This is extremely useful because ItemList doesn't have to retain the DataSource on behalf of the Counter, which makes the DataSource that much cleaner.

// You should use @StateObject for any ObservableObject properties that you create yourself in the object that holds on to that object. So in this case, Counter creates its own DataSource which means that if we want to keep it around, we must mark it as an @StateObject.
