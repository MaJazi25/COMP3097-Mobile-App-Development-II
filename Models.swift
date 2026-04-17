import Foundation

struct ShoppingItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var price: Double
    var quantity: Int
    var notes: String = ""
    var isPurchased: Bool = false

    var total: Double {
        price * Double(quantity)
    }
}

struct ShoppingGroup: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var taxRate: Double
    var items: [ShoppingItem] = []

    var subtotal: Double {
        items.reduce(0) { $0 + $1.total }
    }

    var taxAmount: Double {
        subtotal * taxRate / 100
    }

    var total: Double {
        subtotal + taxAmount
    }
}
