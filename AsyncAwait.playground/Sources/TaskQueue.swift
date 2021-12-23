import Foundation

public actor TaskQueue {
    private let concurrency: Int
    private var running: Int = 0
    private var queue = [CheckedContinuation<Void, Never>]()

    public init(concurrency: Int) {
        self.concurrency = concurrency
    }

    public func enqueue<T>(operation: @escaping @Sendable () async throws -> T) async throws -> T {
        try Task.checkCancellation()

        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            queue.append(continuation)
            tryRunEnqueued()
        }

        defer {
            running -= 1
            tryRunEnqueued()
        }
        try Task.checkCancellation()
        return try await operation()
    }

    private func tryRunEnqueued() {
        guard !queue.isEmpty else { return }
        guard running < concurrency else { return }

        running += 1
        let continuation = queue.removeFirst()
        continuation.resume()
    }
}
