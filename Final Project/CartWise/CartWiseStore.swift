import SwiftUI
import Combine

final class CartWiseStore: ObservableObject {
    @Published var groups: [ShoppingGroup] = [] {
        didSet {
            saveGroups()
        }
    }

    private let key = "cartwise_groups"

    init() {
        loadGroups()

        if groups.isEmpty {
            groups = [
                ShoppingGroup(
                    name: "Food",
                    taxRate: 0,
                    items: [
                        ShoppingItem(name: "Milk", price: 4.40, quantity: 2, notes: "2L"),
                        ShoppingItem(name: "Bread", price: 3.10, quantity: 1, notes: "Whole wheat")
                    ]
                ),
                ShoppingGroup(
                    name: "Medication",
                    taxRate: 0,
                    items: [
                        ShoppingItem(name: "Pain Relief", price: 18.99, quantity: 1)
                    ]
                ),
                ShoppingGroup(
                    name: "Cleaning Products",
                    taxRate: 13,
                    items: [
                        ShoppingItem(name: "Dish Soap", price: 4.99, quantity: 1, notes: "Brand / size"),
                        ShoppingItem(name: "Paper Towels", price: 7.50, quantity: 2),
                        ShoppingItem(name: "Laundry Detergent", price: 12.99, quantity: 1)
                    ]
                ),
                ShoppingGroup(
                    name: "Personal Care",
                    taxRate: 13,
                    items: [
                        ShoppingItem(name: "Soap", price: 15.80, quantity: 1)
                    ]
                )
            ]
        }
    }

    var overallSubtotal: Double {
        groups.reduce(0) { $0 + $1.subtotal }
    }

    var overallTax: Double {
        groups.reduce(0) { $0 + $1.taxAmount }
    }

    var overallTotal: Double {
        groups.reduce(0) { $0 + $1.total }
    }

    var totalItemCount: Int {
        groups.reduce(0) { result, group in
            result + group.items.reduce(0) { $0 + $1.quantity }
        }
    }

    var purchasedItemCount: Int {
        groups.reduce(0) { result, group in
            result + group.items.filter { $0.isPurchased }.count
        }
    }

    func addGroup(name: String, taxRate: Double) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }

        let groupExists = groups.contains {
            $0.name.lowercased() == cleanName.lowercased()
        }

        guard !groupExists else { return }

        let validTaxRate = max(0, taxRate)
        groups.append(ShoppingGroup(name: cleanName, taxRate: validTaxRate))
    }

    func updateGroup(id: UUID, name: String, taxRate: Double) {
        guard let index = groups.firstIndex(where: { $0.id == id }) else { return }

        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }

        let validTaxRate = max(0, taxRate)

        groups[index].name = cleanName
        groups[index].taxRate = validTaxRate
    }

    func deleteGroup(id: UUID) {
        groups.removeAll { $0.id == id }
    }

    func addItem(to groupID: UUID, name: String, price: Double, quantity: Int, notes: String) {
        guard let groupIndex = groups.firstIndex(where: { $0.id == groupID }) else { return }

        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty else { return }

        let validPrice = max(0, price)
        let validQuantity = max(1, quantity)

        let item = ShoppingItem(
            name: cleanName,
            price: validPrice,
            quantity: validQuantity,
            notes: cleanNotes
        )

        groups[groupIndex].items.append(item)
    }

    func updateItem(groupID: UUID, itemID: UUID, name: String, price: Double, quantity: Int, notes: String) {
        guard let groupIndex = groups.firstIndex(where: { $0.id == groupID }) else { return }
        guard let itemIndex = groups[groupIndex].items.firstIndex(where: { $0.id == itemID }) else { return }

        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty else { return }

        groups[groupIndex].items[itemIndex].name = cleanName
        groups[groupIndex].items[itemIndex].price = max(0, price)
        groups[groupIndex].items[itemIndex].quantity = max(1, quantity)
        groups[groupIndex].items[itemIndex].notes = cleanNotes
    }

    func deleteItem(groupID: UUID, itemID: UUID) {
        guard let groupIndex = groups.firstIndex(where: { $0.id == groupID }) else { return }
        groups[groupIndex].items.removeAll { $0.id == itemID }
    }

    func togglePurchased(groupID: UUID, itemID: UUID) {
        guard let groupIndex = groups.firstIndex(where: { $0.id == groupID }) else { return }
        guard let itemIndex = groups[groupIndex].items.firstIndex(where: { $0.id == itemID }) else { return }

        groups[groupIndex].items[itemIndex].isPurchased.toggle()
    }

    func group(for id: UUID) -> ShoppingGroup? {
        groups.first { $0.id == id }
    }

    func clearAllData() {
        groups.removeAll()
    }

    private func saveGroups() {
        guard let data = try? JSONEncoder().encode(groups) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func loadGroups() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        guard let savedGroups = try? JSONDecoder().decode([ShoppingGroup].self, from: data) else { return }
        groups = savedGroups
    }
}