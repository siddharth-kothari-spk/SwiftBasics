/// courtsey: https://www.donnywals.com/using-map-flatmap-and-compactmap-in-combine/
import Combine

// basic publisher that outputs integers
let intPublisher = [1, 2, 3].publisher

// publisher using a CurrentValueSubject
let intSubject = CurrentValueSubject<Int, Never>(1)
intSubject.sink(receiveValue: { int in
  myLabel.text = "Number \(int)"
})

//  To be able to use the intSubject as a direct driver for myLabel.text we need to transform its output so it becomes a string. We can do this using map:
intSubject
    .map{ intValue in "Number: \(intValue)"}
    .assign(to: \.text, on: myLabel)


// compactMap
let optionalPublisher = [1,2,3,nil,4,nil,5,nil].publisher.compactMap{$0}.sink(receiveValue: {int in
    print("Received: \(int)")
})

// flatMap
// Combine's map operations don't operate on arrays. They operate on publishers. This means that when you map over a publisher you transform its published values one by one. Using compactMap leads to the omission of nil from the published values. If publishers in Combine are analogous to collections when using map and compactMap, then publishers that we can flatten nested publishers with flatMap.

[1, 2, 3].publisher.flatMap({ int in
  return (0..<int).publisher
  }).sink(receiveCompletion: { _ in }, receiveValue: { value in
    print("value: \(value)")
  })
// all nested publishers are squashed and converted to a single publisher that outputs the values from all nested publishers, making it look like a single publisher.

// flatMap(maxPublishers:)
// Using flatMap(maxPublishers:) makes sure that you only have a fixed number of publishers active. Once one of the publishers created by flatMap completes, the source publisher is asked for the next value which will then also be mapped into a publisher.

["url1", "url2"]
  .flatMap(maxPublishers: .max(1)) { url in
    return URLSession.shared.dataTaskPublisher(for: url)
  }

// The preceding code shows an example where a publisher that emits URLs over time and transforms each emitted URL into a data task publisher. Because maxPublishers is set to .max(1), only one data task publisher can be active at a time. The publisher can choose whether it drops or accumulates generated URLs while flatMap isn't ready to receive them yet.

// A similar effect can be achieved using map and the switchToLatest operator, except this operator ditches the older publishers in favor of the latest one.

["url1", "url2"]
  .map { url in
    return URLSession.shared.dataTaskPublisher(for: url)
  }
  .switchToLatest()
//The map in the preceding code transforms URLs into data task publishers, and by applying switchToLatest to the output of this map, any subscribers will only receive values emitted by the lastest publisher that was output by map. This means if aPublisherThatEmitsURLs would emit several URLs in a row, we'd only receive the result of the last emitted URL.
