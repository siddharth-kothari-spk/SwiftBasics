import Foundation

public typealias VoidClosure = () -> Void
public typealias Closure<T> = (T) -> Void

public class CompletionOperation: AsyncOperation {
    // MARK: Lifecycle

    public init(completeBlock: Closure<VoidClosure?>?) {
        self.completeBlock = completeBlock
    }

    // MARK: Public

    override public func main() {
        DispatchQueue.main.async { [weak self] in
            self?.completeBlock? {
                DispatchQueue.main.async {
                    self?.state = .finished
                }
            }
        }
    }

    // MARK: Private

    private let completeBlock: Closure<VoidClosure?>?
}
