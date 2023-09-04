/// courtsey: https://www.donnywals.com/recursively-execute-a-paginated-network-call-with-combine/
///
import Combine

// expectation:
/*
networking.loadPages()
  .sink(receiveCompletion: { _ in
    // handle errors
  }, receiveValue: { items in
    print(items)
  })
  .store(in: &cancellables)
*/

// loadPages() will return a publisher that emits data for all pages at once. I don't want to receive all intermediate pages in my sink. The publisher completes immediately after delivering my complete data set.

//The tricky bit here is that this means that in loadPages() we'll need to somehow create a publisher that collects the responses from several network calls, bundles them into one big result, and outputs them to the created publisher.

