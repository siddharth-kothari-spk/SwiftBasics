// https://www.donnywals.com/configuring-error-types-when-using-flatmap-in-combine/

import Combine

// Understanding how flatMap works with Error types

//In Combine, every publisher has a defined Output and Failure type. For example, a DataTaskPublisher has a tuple of Data and URLResponse as its Output ((data: Data, response: URLResponse)) and URLError as its Failure.

//When you want to apply a flatMap to the output of a data task publisher like I do in the following code snippet, you'll run into a compiler error:

URLSession.shared.dataTaskPublisher(for: someURL)
  .flatMap({ output -> AnyPublisher<Data, Error> in

  })
//If you've written code like this before, you'll probably consider the following compiler error to be normal:

//Instance method flatMap(maxPublishers:_:) requires the types URLSession.DataTaskPublisher.Failure (aka URLError) and Error be equivalent

// a publisher has a single predefined error type. A data task uses URLError. When you apply a flatMap to a publisher, you can create a new publisher that has a different error type.

// Since your flatMap will only receive the output from an upstream publisher but not its Error. Combine doesn't like it when your flatMap returns a publisher with an error type that does not align with the upstream publisher. After all, errors from the upstream are sent directly to subscribers. And so are errors from the publisher created in your flatMap. If these two errors aren't the same, then what kind of error does a subscriber receive?

//To avoid this problem, we need to make sure that an upstream publisher and a publisher created in a flatMap have the same Failure. One way to do this is to apply mapError to the upstream publisher to cast its errors to Error:

URLSession.shared.dataTaskPublisher(for: someURL)
  .mapError({ $0 as Error })
  .flatMap({ output -> AnyPublisher<Data, Error> in

  })

//To avoid this problem, we need to make sure that an upstream publisher and a publisher created in a flatMap have the same Failure. One way to do this is to apply mapError to the upstream publisher to cast its errors to Error:

URLSession.shared.dataTaskPublisher(for: someURL)
  .mapError({ $0 as Error })
  .flatMap({ output -> AnyPublisher<Data, Error> in

  })


//You can apply mapError to any publisher that can fail, and you can always cast the error to Error since in Combine, a publisher's Failure must conform to Error.

//This means that if you're returning a publisher in your flatMap that has a specific error, you can also apply mapError to the publisher created in your flatMap to make your errors line up:

URLSession.shared.dataTaskPublisher(for: someURL)
  .mapError({ $0 as Error })
  .flatMap({ [weak self] output -> AnyPublisher<Data, Error> in
    // imagine that processOutput is a function that returns AnyPublisher<Data, ProcessingError>
    return self?.processOutput(output)
      .mapError({ $0 as Error })
      .eraseToAnyPublisher()
  })

