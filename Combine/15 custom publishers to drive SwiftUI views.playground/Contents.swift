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

