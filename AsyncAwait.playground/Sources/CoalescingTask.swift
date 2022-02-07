import Foundation

public actor CoalescingTask<Success: Sendable> {
    private let operationBlock: (@Sendable () async throws -> Success)
    private var task: Task<Success, Error>? = nil
    private var listeners: Int = 0

    public init(operation: @escaping @Sendable () async throws -> Success) {
        operationBlock = operation
    }

    func finish() {
        listeners -= 1

        print("CT - finish listener", listeners)

        if listeners == 0 {
            print("CT - all listeners gone. canceling task ✌🏽")

            task?.cancel()
            task = nil
        }
    }

    public func run() async throws -> Success {
        try Task.checkCancellation()

        listeners += 1
        print("CT run listeners", listeners)

        if task == nil {
            print("CT creating task")
            task = Task {
                try await self.operationBlock()
            }
        }

        return try await withTaskCancellationHandler {
            print("CT launching task")

            defer {
                if !Task.isCancelled { finish() }
            }

            return try await task!.value
        } onCancel: {
            // Is it possible for run to happen between here and self.cancel()?

            print("CT cancel task")
            Task {
                await self.finish()
            }
        }
    }

}
