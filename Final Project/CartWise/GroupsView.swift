import SwiftUI

struct GroupsView: View {
    @EnvironmentObject var store: CartWiseStore
    @State private var searchText = ""
    @State private var showAddGroup = false

    var filteredGroups: [ShoppingGroup] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return store.groups
        }

        return store.groups.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            Color(.systemTeal).opacity(0.08)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    CardBox {
                        VStack(alignment: .center, spacing: 4) {
                            Text("CartWise")
                                .font(.title2)
                                .bold()

                            Text("My Groups")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    SearchBarView(text: $searchText, placeholder: "Search groups...")

                    VStack(spacing: 12) {
                        ForEach(filteredGroups) { group in
                            NavigationLink(value: AppRoute.groupDetail(group.id)) {
                                CardBox {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("\(group.name) Tax: \(Int(group.taxRate))%")
                                                .font(.headline)
                                                .foregroundColor(.black)

                                            Text("Subtotal: \(group.subtotal.moneyText)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()

                                        Text("Total: \(group.total.moneyText)")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }

                    CardBox {
                        HStack {
                            Spacer()
                            Text("Overall Total: \(store.overallTotal.moneyText)")
                                .font(.title3)
                                .bold()
                            Spacer()
                        }
                    }

                    HStack {
                        Button("+ Add Group") {
                            showAddGroup = true
                        }
                        .font(.headline)
                        .foregroundColor(.black)

                        Spacer()

                        NavigationLink(value: AppRoute.summary) {
                            Text("Summary")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddGroup) {
            GroupFormView { name, taxRate in
                store.addGroup(name: name, taxRate: taxRate)
            }
        }
    }
}
