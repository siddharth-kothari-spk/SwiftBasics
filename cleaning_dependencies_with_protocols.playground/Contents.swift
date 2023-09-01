/// courtsey: https://www.donnywals.com/cleaning-up-your-dependencies-with-protocols/
///
import UIKit

// Dependency injection is the practice of making sure that no object creates or manages its own dependencies.

//  Imagine you’re building a login page for an app and you have separate service objects for registering a user and logging them in , wrapping these services in a LoginPageViewModel.

class LoginViewController: UIViewController {
  let viewModel: LoginViewModel
}

protocol LoginService {
  func login(_ email: String, password: String) -> Promise<Result<User, Error>>
}
protocol RegisterService {
  func register(_ email: String, password: String) -> Promise<Result<User, Error>>
}

struct LoginViewModel {
  let loginService: LoginService
  let registerService: RegisterService
}

// Notice how none of these definitions create instances of their dependencies. This means that the object that is responsible for creating a LoginViewController is also responsible for creating (or obtaining) a LoginViewModel object. And since LoginViewModel depends on two service objects, the object that creates a LoginViewModel must also be able to create (or obtain) the service objects it depends on.
