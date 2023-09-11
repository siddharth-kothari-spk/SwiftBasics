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
