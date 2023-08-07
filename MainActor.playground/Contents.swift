import UIKit

///courtsey: https://www.avanderlee.com/swift/mainactor-dispatch-main-thread/


// MainActor is a new attribute introduced in Swift 5.5 as a global actor providing an executor which performs its tasks on the main thread. Can be used for properties, methods, instances, and closures to perform tasks on the main thread.


@globalActor
actor SidActor {
    static let shared = SidActor()
}

// We can see Global Actors as singletons: only one instance exists.

@SidActor
final class SidFetcher {
    // ..
}

// we could add the @MainActor attribute to a view model to perform all tasks on the main thread
@MainActor
final class HomeViewModel {
    // ..
}

// We can only annotate a class with a global actor if it has no superclass, the superclass is annotated with the same global actor, or the superclass is NSObject. A subclass of a global-actor-annotated class must be isolated to the same global actor.

// we might want to define individual properties with a global actor

final class IndividualPropertyModel {
    @MainActor var stats: [String] = []
    
   /* func updateStats() {
        stats = ["new stat"] // error : Main actor-isolated property 'stats' can not be mutated from a non-isolated context
    } */
    
    @MainActor func updateStats() {
        stats = ["new stat"] // this will work
    }
    
    // you can even mark closures to perform on the main thread:
    func updateClosureOnMain(completion: @MainActor @escaping () -> ()) {
        Task {
            await longOperation()
            await completion()
        }
    }
    
    func longOperation() {
        
    }
}

// We can also use MainActor directly thoush we have not defined it anywhere in body

final class UpdateImages {
    func updateImages() {
        Task {
            await MainActor.run {
                // task to do on main thread
            }
        }
    }
}



// Before Main Actor
func fetchImage(for url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data, let image = UIImage(data: data) else {
            DispatchQueue.main.async {
                completion(.failure(ImageFetchingError.imageDecodingFailed))
            }
            return
        }

        DispatchQueue.main.async {
            completion(.success(image))
        }
    }.resume()
}

// After Main Actor
@MainActor
func fetchImage(for url: URL) async throws -> UIImage {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let image = UIImage(data: data) else {
        throw ImageFetchingError.imageDecodingFailed
    }
    return image
}


enum ImageFetchingError: Error {
    case imageDecodingFailed
}
