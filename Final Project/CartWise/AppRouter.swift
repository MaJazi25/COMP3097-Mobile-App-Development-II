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
        showWelcome = true
        path = NavigationPath()
    }

    func goToGroupDetail(id: UUID) {
        showWelcome = false
        path.append(AppRoute.groupDetail(id))
    }

    func goToSummary() {
        showWelcome = false
        path.append(AppRoute.summary)
    }

    func resetNavigation() {
        path = NavigationPath()
    }
}