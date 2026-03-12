import SwiftUI
import Combine

enum AppRoute: Hashable {
    case groupDetail(UUID)
    case summary
}

final class AppRouter: ObservableObject {
    @Published var showWelcome = true
    @Published var path = NavigationPath()

    func goToGroups() {
        showWelcome = false
        path = NavigationPath()
    }

    func goHome() {
        showWelcome = false
        path = NavigationPath()
    }
}
