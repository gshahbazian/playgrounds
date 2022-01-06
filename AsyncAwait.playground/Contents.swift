import UIKit
import Dispatch
import Package

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

        Task {
            for await val in _hey.sequence {
                print("VALUE 1: ", val)
            }
        }

        Task {
            for await val in _hey.sequence {
                print("VALUE 2: ", val)
            }
        }
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
