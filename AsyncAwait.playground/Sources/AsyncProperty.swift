import Foundation
import Asynchrone

@propertyWrapper
public class AsyncProperty<Element> {
    public let sequence: AnyAsyncSequenceable<Element>
    private let continuation: AsyncStream<Element>.Continuation

    public init(_ initialValue: Element) {
        value = initialValue
        let (stream, continuation) = AsyncStream<Element>.pipe()
        self.continuation = continuation

        let shared = stream.shared()
        sequence = shared.eraseToAnyAsyncSequenceable()
    }

    public convenience init(wrappedValue: Element) {
        self.init(wrappedValue)
    }

    deinit {
        continuation.finish()
    }

    public var value: Element {
        didSet {
            continuation.yield(value)
        }
    }

    @inlinable
    public var wrappedValue: Element {
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
