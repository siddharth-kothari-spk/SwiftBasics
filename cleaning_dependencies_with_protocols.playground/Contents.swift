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


// Using dependency injection makes your code more flexible, testable

// As your app grows, you’ll typically find that the number of dependencies that you manage in your application grows too. It’s not uncommon for a single object to (indirectly) depend on a dozen other objects that must be injected into the object’s initializer. This leads to unwieldy initializers which is can be hard to read. On top of this, it makes writing tests more tedious too because if you want to test an object with many dependencies, you’ll have to create an instance of each dependency in your test.

// Cleaning up common dependencies is sometimes done by creating one or more dependency containers

struct Services {
  let loginService: LoginService
  let registerService: RegisterService
  let feedService: FeedService
  let shopService: ShopService
  let artistService: ArtistService
  let profileService: ProfileService
}

// now our LoginViewModel is
struct LoginViewModel {
  let loginService: LoginService
  let registerService: RegisterService

  init(services: Services) {
    loginService = services.loginService
    regsisterService = services.regsisterService
  }
}

