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



//If a view receives an ObservableObject in its initializer you can use @ObservedObject because the view does not create that instance on its own:

struct CounterObservedObject: View {
  // the DataSource must now be passed to Counter's initializer
  @ObservedObject var dataSource: DataSource

  var body: some View {
    VStack {
      Button("Increment counter") {
        dataSource.counter += 1
      }

      Text("Count is \(dataSource.counter)")
    }
  }
}

// Keep in mind though that this does not solve the problem in all cases. If the object that creates Counter (or your view that has an @ObservedObject) does not retain the ObservableObject, a new instance is created every time that view redraws its body:

struct ItemListInjectingDataSource: View {
  @State private var items = ["hello", "world"]

  var body: some View {
    VStack {
      Button("Append item to list") {
        items.append("test")
      }

      List(items, id: \.self) { name in
        Text(name)
      }

      // a new data source is created for every redraw
        CounterObservedObject(dataSource: DataSource())
    }
  }
}

// However, this does not mean that you should mark all of your @ObservedObject properties as @StateObject. In this last case, it might be the intent of the ItemList to create a fresh DataSource every time the view is redrawn. If you'd have marked Counter.dataSource as @StateObject the new instance would be ignored and your app might now have a new hidden bug.

// A not completely unimportant implication of @StateObject is performance. If you're using an @ObservedObject that's recreated often that might harm your view's rendering performance. Since @StateObject is not recreated for every view re-render, it has a far smaller impact on your view's drawing cycle. Of course, the impact might be minimal for a small object, but could grow rapidly if your @ObservedObject is more complex.

//So in short, you should use @StateObject for any observable properties that you initialize in the view that uses it. If the ObservableObject instance is created externally and passed to the view that uses it mark your property with @ObservedObject.
