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
