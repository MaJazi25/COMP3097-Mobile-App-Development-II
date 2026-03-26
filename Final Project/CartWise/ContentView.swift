import SwiftUI

struct ContentView: View {
    @StateObject private var store = CartWiseStore()
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack {
            if router.showWelcome {
                VStack(spacing: 20) {
                    Text("CartWise")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Manage your shopping easily")
                        .foregroundColor(.gray)

                    Text("Groups: \(store.groups.count)")
                    Text("Total: $\(store.overallTotal, specifier: "%.2f")")

                    Button("Get Started") {
                        router.goToGroups()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                List {
                    ForEach(store.groups) { group in
                        VStack(alignment: .leading) {
                            Text(group.name)
                                .font(.headline)

                            Text("Items: \(group.items.count)")
                                .font(.subheadline)

                            Text("Total: $\(group.total, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                    }
                }
                .navigationTitle("CartWise")
                .toolbar {
                    Button("Home") {
                        router.goHome()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}