import Foundation

@propertyWrapper
public class AsyncProperty<Value> {
    public let stream: AsyncStream<Value>

    private let continuation: AsyncStream<Value>.Continuation

    public init(_ initialValue: Value) {
        value = initialValue
        (stream, continuation) = AsyncStream.pipe()
    }

    public convenience init(wrappedValue: Value) {
        self.init(wrappedValue)
    }

    deinit {
        continuation.finish()
    }

    public var value: Value {
        didSet {
            continuation.yield(value)
        }
    }

    @inlinable
    public var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }
}

extension AsyncStream {
    public static func pipe() -> (stream: AsyncStream, continuation: AsyncStream.Continuation) {
        var continuation: AsyncStream.Continuation!
        let stream = self.init { innerContinuation in
            continuation = innerContinuation
        }
        return (stream, continuation)
    }
}
