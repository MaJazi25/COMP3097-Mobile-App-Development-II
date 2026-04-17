import SwiftUI

@main
struct CartWiseApp: App {
    @StateObject private var store = CartWiseStore()
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .environmentObject(router)
        }
    }
}
