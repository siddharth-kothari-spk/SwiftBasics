import Foundation


public class AsyncOperation: Operation {
    
    public enum State: String {
            case ready
            case executing
            case finished

            // MARK: Fileprivate

            fileprivate var keyPath: String {
                "is" + rawValue.capitalized
            }
        }
    
    public var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(for: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override open var isAsynchronous: Bool {
        true
    }
    
    override open var isReady: Bool {
        super.isReady && self.state == .ready
    }
    
    override open var isExecuting: Bool {
            self.state == .executing
        }

        override open var isFinished: Bool {
            self.state == .finished
        }

        override open func start() {
            if isCancelled {
                state = .finished
                return
            }
            main()
            state = .executing
        }

        override open func cancel() {
            super.cancel()
            state = .finished
        }

}
