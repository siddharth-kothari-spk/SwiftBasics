import UIKit
//courtsey: https://www.avanderlee.com/concurrency/asyncsequence/

// AsyncSequence is just a protocol. It defines how to access values but doesn’t generate or contain values. Implementors of the AsyncSequence protocol provide an AsyncIterator and take care of developing and potentially storing values.

struct Counter: AsyncSequence {
    typealias Element = Int

    let limit: Int

    struct AsyncIterator : AsyncIteratorProtocol {
        let limit: Int
        var current = 1
        mutating func next() async -> Int? {
            guard !Task.isCancelled else {
                return nil
            }

            guard current <= limit else {
                return nil
            }

            let result = current
            current += 1
            return result
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(limit: limit)
    }
}

for await count in Counter(limit: 10) {
    print(count)
}
print("Counter finished")


// Many of the regular Sequence operators are also available for asynchronous sequences.

for await count in Counter(limit: 10).filter({ value in
    value%2 == 0
}) {
    print(count)
}
print("Filter counter finished")


let stream = Counter(limit: 10).map { value in
    value%2 == 0 ? "Even" : "Odd"
}
for await value in stream {
    print(value)
}
print("Map counter finished")

let contains = await Counter(limit: 10).contains(5)
print(contains)
