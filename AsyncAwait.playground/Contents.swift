import UIKit

actor TestActor {
    func doSleep() async throws {
        Thread.isMainThread

        try await Task.sleep(nanoseconds: 3_000_000_000)

        Task.isCancelled
        Thread.isMainThread
    }
}

let ct = CoalescingTask<Int> {
    print("AA - starting ct work 🛠")
    try await Task.sleep(nanoseconds: 2_000_000_000)
    print("AA - finishing ct work 🛠", Task.isCancelled)
    return Int.random(in: 0...100)
}

@MainActor
class MainClass {
    let act = TestActor()

    func run1() async {
        let subtask = Task {
            Thread.isMainThread

            try await act.doSleep()

            Thread.isMainThread
            Task.isCancelled
        }

        await subtask.result
        Task.isCancelled
    }

    func run2() async {
        let s1 = Task {
            print("AA - task 1 start")
            try await ct.run()

            Task.isCancelled
            try Task.checkCancellation()
            print("AA - task 1 finish")
        }

        let s2 = Task {
            print("AA - task 2 start")
            try await ct.run()

            Task.isCancelled
            try Task.checkCancellation()
            print("AA - task 2 finish")
        }

        try! await Task.sleep(nanoseconds: 1_000_000_000)

//        let s3 = Task.detached(priority: .background) {
//            try! await Task.sleep(nanoseconds: 600)
//            print("AA - sleep task run")
//            try? await ct.run()
//        }

        print("AA - canceling parent tasks")
        s2.cancel()
        s1.cancel()

//        await s3.value

        print("AA - finished all")
    }
}

let playgroundTask = Task {
    let mc = await MainClass()
    await mc.run2()
}
