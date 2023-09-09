// courtsey: https://www.donnywals.com/implementing-an-infinite-scrolling-list-with-swiftui-and-combine/

import Combine

struct EndlessList: View {
  @StateObject var dataSource = ContentDataSource()

  var body: some View {
    List(dataSource.items) { item in
      Text(item.label)
        .onAppear {
          dataSource.loadMoreContentIfNeeded(currentItem: item)
        }
        .padding(.all, 30)
    }
      // Since I made the ContentDataSource's isLoadingPage property @Published, we can use it to add a loading indicator to the bottom of the list to show the user we're loading a new page in case the page isn't loaded by the time the user reaches the end of the list:
      if dataSource.isLoadingPage {
              ProgressView()
            }
  }
}

// In SwiftUI, onAppear is called when a view is rendered by the system
// A List will only keep a certain number of views around while rendering so we can use onAppear to hook into List's rendering. Since we have access to the item that's being rendered, we can ask the data source to load more data if needed depending on the item that's being rendered. If this is one of the last items in the data source, we can kick off a page load and add more items to the data source.

class ContentDataSource: ObservableObject {
    @Published var items = [ListItem]()
    @Published var isLoadingPage = false
    private var currentPage = 1
    private var canLoadMorePages = true
    
    init() {
        loadMoreContent()
    }
    
    func loadMoreContentIfNeeded(currentItem item: ListItem?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    private func loadMoreContent() {
        // check whether I'm already loading a page, and whether there are more pages to load.
        guard !isLoadingPage && canLoadMorePages else {
          return
        }

        isLoadingPage = true

        let url = URL(string: "https://s3.eu-west-2.amazonaws.com/com.donnywals.misc/feed-\(currentPage).json")!
        
        // create a dataTaskPublisher to load the URL and use Combine's handleEvents operator to apply side-effects to data source when a response was loaded.
        
        URLSession.shared.dataTaskPublisher(for: url)
          .map(\.data)
          .decode(type: ListResponse.self, decoder: JSONDecoder())
        //prefixed handleEvents with receive(on: DispatchQueue.main) because modify @Published property in the handleEvents operator which might change view and that must be done on the main thread.
          .receive(on: DispatchQueue.main)
          .handleEvents(receiveOutput: { response in
              // update the canLoadMorePages boolean, set isLoadingPage back to false because the load is complete and increment the currentPage
            self.canLoadMorePages = response.hasMorePages
            self.isLoadingPage = false
            self.currentPage += 1
          })
        //In the map return a value that merges the current list of items with the newly loaded items.
          .map({ response in
            return self.items + response.items
          })
        // catch any erros that might have occured during the page load and replace them with a publisher that re-emits the current list of items.
          .catch({ _ in Just(self.items) })
        // update the items property use Combine's new assign(to:) operator. This operator can pipe the output from a publisher directly into an @Published property without needing to manually subscribe to it.
          .assign(to: $items)
      }
    }
