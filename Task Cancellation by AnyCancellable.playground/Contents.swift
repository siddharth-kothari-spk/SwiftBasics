import UIKit
import Foundation

/// courtsey: https://medium.com/mobimeo-technology/effective-task-cancellation-in-swift-by-leveraging-combines-anycancellable-7814b50fc8c8
///
/// The Swift Programming Language book states that Swift concurrency uses a cooperative cancellation model. This means that although all child tasks will be informed when their parent task has been canceled, they still continue to run. A task can check whether it has been canceled by either calling try Task.checkCancellation, which raises a CancellationError, or by checking the value of Task.isCanceled to return a partial result or a fallback value. Lastly, a task can be canceled by calling the cancel() method on it.
///

class FoodViewModel: ObservableObject {
    enum State {
        case idle, loading, vegetable(Vegetable), error(Error)
    }

    @Published private(set) var state: State = .idle

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func displayVegetable(id: String) async {
        do {
            state = .loading
            state = try await .vegetable(loadVegetable(id: id))
        } catch let error as URLError where error.code == .cancelled {
            state = .idle
        } catch {
            state = .error(error)
        }
    }

    private func loadVegetable(id: String) async throws -> Vegetable {
        try await networkService.request(endpoint: .vegetable(id: id))
    }
}

/// If this view model were to control a SwiftUI view and your app supports iOS 15.0+, the best approach is probably to call displayVegetable() from within SwiftUI’s task modifier.
/// It is called when the view first appears and is marked as canceled when the view is no longer displayed on screen. I suppose we could write our own task ViewModifier which starts a task in onAppear and cancels it again in onDisappear , but let’s look at ways to manually control the task lifetime instead.
/// While we could expose a cancel method to the view that is called in onDisappear, arguably a more elegant approach is to tie the lifetime of the task to that of the view model:
///
class FoodViewModel: ObservableObject {
    ...
  
    private var task: Task<Void, Never>? // Reference to the loading task

    deinit {
        task?.cancel() // Make sue the task is canceled if it is no longer needed
    }

    func displayVegetable(id: String) {
        task = Task { @MainActor [weak self] in
            guard let self else { return } // Captures self and prevents deinit before task is finished
            do {
                self.state = .loading
                self.state = try await .vegetable(self.loadVegetable(id: id))
            } catch ... {
                ...
            }
        }
    }
  
    ...
}


/// As you can see it get’s a little bit more involved. We now have to keep a reference of the task and make sure we cancel the task when the view model is de-initialized. However, there is only one problem with this code, deinit is not called
/// This is because we create a reference cycle by capturing a strong reference to self in the task’s closure in the guard self statement. Lets fix that by shaking off our guard-self-dance habit and guard the statement in the suspension point instead.

class FoodViewModel: ObservableObject {
    ...
  
    private var task: Task<Void, Never>?

    deinit {
        task?.cancel()
    }

    func displayVegetable(id: String) {
        task = Task { @MainActor [weak self] in
            do {
                self?.state = .loading
                guard let vegetable = try await self?.loadVegetable(id: id) else {
                    return
                }
                self?.state = .vegetable(vegetable)
            } catch ... {
                ...
            }
        }
    }
}

/// ----------------------------------
//// Single task cancellation using AnyCancellable
/// ----------------------------------
///AnyCancellable has the advantage of being automatically canceled by calling its cancel function as soon as there is no more reference to it.
///Let’s create a simple extension on Task to make use of this.

import Combine

extension Task {
  func eraseToAnyCancellable() -> AnyCancellable {
        AnyCancellable(cancel)
    }
}

///With this in place we can omit the deinit and store an AnyCancellable instead of the task.

class FoodViewModel: ObservableObject {
    ...
  
    private var cancellable: AnyCancellable?

    func displayVegetable(id: String) {
        cancellable = Task { @MainActor [weak self, networkService] in
            ...
        }.eraseToAnyCancellable()
    }
  
    ...
}

/// Another advantage of this approach is the ability to always use the same reference when you have requests that alternate. Let’s assume we have another function called displayFruit(id:). If your view is only able to display either a fruit or vegetable you can use the same reference for both, and don’t need to worry about cancelling the previous task.

class FoodViewModel: ObservableObject {
    ...
  
    private var cancellable: AnyCancellable?

    // Canceled automatically if a fruit is requested
    func displayVegetable(id: String) {
        cancellable = Task { @MainActor [weak self, networkService] in
            ...
        }.eraseToAnyCancellable()
    }

   // Canceled automatically if a vegetable is requested
    func displayFruit(id: String) {
        cancellable = Task { @MainActor [weak self, networkService] in
            ...
        }.eraseToAnyCancellable()
    }
  
    ...
}

/// ----------------------------------
/// Cancelling multiple tasks
/// ----------------------------------
/// Now that we have our first Combine-like API, we can take the next obvious step by introducing a function analogous to Combine’s store(in: Set<AnyCancellable>).

import Combine

extension Task {
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(AnyCancellable(cancel))
    }
}

///It allows us to tie the lifecycle of multiple tasks to a single reference. And the best part is, it can be used alongside with publisher subscriptions as well. For example, if we go back to our single vegetable request scenario where, which is tied to the views lifecycle and we want to observe our apps user login state, we can conveniently store both cancellation handlers in a single set.

class FoodViewModel: ObservableObject {
    ...
  
    private var cancellables: Set<AnyCancellable> = []

    init(networkService: NetworkService, userModule: UserModule) {
      self.networkService = networkService
      
      userModule.isLoggedInPublisher.sink { isLoggedIn in
          ...
      }
      .store(in: &cancellables)
    }

    func displayVegetable(id: String) {
        Task { @MainActor [weak self, networkService] in
            ...
        }.store(in: &cancellables)
    }
  
    ...
}
