import SwiftUI

@main
struct Jahez_TaskApp: App {
    private let locator = ServiceLocator.shared

    var body: some Scene {
        WindowGroup {
            ContentView(locator: locator)
        }
    }
}
