import UIKit
import Dispatch
import Foundation

@MainActor
class MainClass {
    func run1(date: Date) async throws {
        print("DATE \(date)")
    }
}

let playgroundTask = Task {
    let mc = await MainClass()

    // Warns: "Cannot pass argument of non-sendable type 'Date' across actors"
    try await mc.run1(date: Date.now)
}
