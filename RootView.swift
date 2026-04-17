import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        Group {
            if router.showWelcome {
                WelcomeView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                            if router.showWelcome {
                                router.goToGroups()
                            }
                        }
                    }
            } else {
                NavigationStack(path: $router.path) {
                    GroupsView()
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .groupDetail(let groupID):
                                GroupDetailView(groupID: groupID)
                            case .summary:
                                SummaryView()
                            }
                        }
                }
            }
        }
    }
}
