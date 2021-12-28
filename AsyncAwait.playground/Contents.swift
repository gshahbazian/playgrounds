import UIKit
import Dispatch

@MainActor
class MainClass {

    @AsyncProperty var hey = "WOO"

    func run1() async {
        Task {
            for i in 0..<5 {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                self.hey = "HEY \(i)"
            }
        }

        for await val in _hey.stream {
            print("VALUE: ", val)
        }

        print("DONE")
    }
}

let playgroundTask = Task {
    let mc = await MainClass()
    await mc.run1()
}

Task {
    try await Task.sleep(nanoseconds: 3_000_000_000)
//    playgroundTask.cancel()
}
