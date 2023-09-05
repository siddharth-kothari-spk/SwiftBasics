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

