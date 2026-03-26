import SwiftUI

struct GroupDetailView: View {
    @EnvironmentObject var store: CartWiseStore
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) private var dismiss

    let groupID: UUID

    @State private var searchText = ""
    @State private var showPurchasedOnly = false
    @State private var showAddItem = false
    @State private var showEditGroup = false
    @State private var editingItem: ShoppingItem?

    var group: ShoppingGroup? {
        store.groups.first(where: { $0.id == groupID })
    }

    var filteredItems: [ShoppingItem] {
        guard let group else { return [] }

        return group.items.filter { item in
            let matchesSearch = searchText.isEmpty ||
            item.name.localizedCaseInsensitiveContains(searchText) ||
            item.notes.localizedCaseInsensitiveContains(searchText)

            let matchesPurchased = !showPurchasedOnly || item.isPurchased

            return matchesSearch && matchesPurchased
        }
    }

    var body: some View {
        ZStack {
            Color(.systemTeal).opacity(0.08)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    if let group {
                        CardBox {
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: "arrow.left")
                                        Text(group.name)
                                    }
                                    .font(.headline)
                                    .foregroundColor(.black)
                                }

                                Spacer()

                                Button("Home") {
                                    router.goHome()
                                }
                                .font(.subheadline)
                                .foregroundColor(.black)

                                Button("Edit Group") {
                                    showEditGroup = true
                                }
                                .font(.subheadline)
                                .foregroundColor(.black)
                            }
                        }

                        SearchBarView(text: $searchText, placeholder: "Search items...")

                        VStack(spacing: 12) {
                            ForEach(filteredItems) { item in
                                Button {
                                    editingItem = item
                                } label: {
                                    CardBox {
                                        HStack(alignment: .top) {
                                            Button {
                                                store.togglePurchased(groupID: group.id, itemID: item.id)
                                            } label: {
                                                Image(systemName: item.isPurchased ? "checkmark.square.fill" : "square")
                                                    .font(.title3)
                                                    .foregroundColor(.black)
                                            }

                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(item.name)
                                                    .font(.headline)
                                                    .foregroundColor(.black)

                                                Text("Total: \(item.total.moneyText)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }

                                            Spacer()

                                            Text("\(item.price.moneyText) x\(item.quantity)")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                        }

                        CardBox {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Subtotal:")
                                    Spacer()
                                    Text(group.subtotal.moneyText)
                                }

                                HStack {
                                    Text("Tax (\(Int(group.taxRate))%):")
                                    Spacer()
                                    Text(group.taxAmount.moneyText)
                                }

                                HStack {
                                    Text("Total:")
                                    Spacer()
                                    Text(group.total.moneyText)
                                }
                            }
                            .font(.headline)
                        }

                        HStack {
                            Button("+ Add Item") {
                                showAddItem = true
                            }
                            .foregroundColor(.black)

                            Spacer()

                            Button("Clear") {
                                searchText = ""
                            }
                            .foregroundColor(.black)

                            Spacer()

                            Button(showPurchasedOnly ? "All" : "Purchased") {
                                showPurchasedOnly.toggle()
                            }
                            .foregroundColor(.black)

                            Spacer()

                            Button("Delete Purchased") {
                                store.deletePurchasedItems(groupID: group.id)
                            }
                            .foregroundColor(.black)
                        }
                        .padding(.horizontal, 8)
                        .font(.headline)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showAddItem) {
            if let group {
                ItemFormView(
                    groupName: group.name,
                    taxRate: group.taxRate,
                    onSave: { name, price, quantity, notes in
                        store.addItem(to: group.id, name: name, price: price, quantity: quantity, notes: notes)
                    }
                )
            }
        }
        .sheet(item: $editingItem) { item in
            if let group {
                ItemFormView(
                    groupName: group.name,
                    taxRate: group.taxRate,
                    item: item,
                    onSave: { name, price, quantity, notes in
                        store.updateItem(groupID: group.id, itemID: item.id, name: name, price: price, quantity: quantity, notes: notes)
                    },
                    onDelete: {
                        store.deleteItem(groupID: group.id, itemID: item.id)
                    }
                )
            }
        }
        .sheet(isPresented: $showEditGroup) {
            if let group {
                GroupFormView(
                    group: group,
                    onSave: { name, taxRate in
                        store.updateGroup(id: group.id, name: name, taxRate: taxRate)
                    },
                    onDelete: {
                        store.deleteGroup(id: group.id)
                        dismiss()
                    }
                )
            }
        }
    }
}