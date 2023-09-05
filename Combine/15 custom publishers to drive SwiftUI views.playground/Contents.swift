/// courtsey: https://www.donnywals.com/using-custom-publishers-to-drive-swiftui-views/
///
import Combine

// In SwiftUI, views can be driven by an @Published property that's part of an ObservableObject

class DataSource: ObservableObject {
  @Published var names = [String]()
}

struct NamesList: View {
  @ObservedObject var dataSource: DataSource

  var body: some View {
    List(dataSource.names, id: \.self) { name in
      Text(name)
    }
  }
}

// Whenever the DataSource object's names array changes, NamesList will be automatically redrawn.

// Now imagine that our list of names is retrieved through the network somehow and we want to load the list of names in the onAppear for NamesList1

class DataSource1: ObservableObject {
    @Published var names = [String]()
    
    let networkingObject = NetworkingObject()
    let cancellables = Set<AnyCancellable>()
    
    func loadNames() {
        networkingObject.loadNames()
          .receive(on: DispatchQueue.main)
          .sink(receiveValue: { [weak self] names in
            self?.names = names
              // to subscribe to a publisher just so I could update an @Published property. iOS 13
          })
          .store(in: &cancellables)
      }
}

struct NamesList: View {
  @ObservedObject var dataSource: DataSource1

  var body: some View {
    List(dataSource.names, id: \.self) { name in
      Text(name)
    }.onAppear(perform: {
      dataSource.loadNames()
    })
  }
}


// in iOS 14 we can refactor loadNames() and do much better with the new assign(to:) operator:

class DataSource3: ObservableObject {
  @Published var names = [String]()

  let networkingObject = NetworkingObject()

  func loadNames() {
    networkingObject.loadNames()
      .receive(on: DispatchQueue.main)
      .assign(to: &$names)
  }
}

class NetworkingObject {
    func loadNames() -> AnyPublisher<Data, Error> {
        return Just(100)
    }
}

// The assign(to:) operator allows you to assign the output from a publisher directly to an @Published property under one condition. The publisher that you apply the assign(to:) on must have Never as its error type. Note that I had to add an & prefix to $names. The reason for this is that assign(to:) receives its target @Published property as an inout parameter, and inout parameters in Swift are always passed with an & prefix.
