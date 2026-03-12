import SwiftUI

struct ItemFormView: View {
    @EnvironmentObject var router: AppRouter

    let groupName: String
    let taxRate: Double
    var item: ShoppingItem?
    var onSave: (String, Double, Int, String) -> Void
    var onDelete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var priceText: String
    @State private var quantity: Int
    @State private var notes: String

    init(
        groupName: String,
        taxRate: Double,
        item: ShoppingItem? = nil,
        onSave: @escaping (String, Double, Int, String) -> Void,
        onDelete: (() -> Void)? = nil
    ) {
        self.groupName = groupName
        self.taxRate = taxRate
        self.item = item
        self.onSave = onSave
        self.onDelete = onDelete
        _name = State(initialValue: item?.name ?? "")
        _priceText = State(initialValue: item == nil ? "" : String(format: "%.2f", item!.price))
        _quantity = State(initialValue: item?.quantity ?? 1)
        _notes = State(initialValue: item?.notes ?? "")
    }

    var priceValue: Double {
        Double(priceText) ?? 0
    }

    var previewSubtotal: Double {
        priceValue * Double(quantity)
    }

    var previewTax: Double {
        previewSubtotal * taxRate / 100
    }

    var previewTotal: Double {
        previewSubtotal + previewTax
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemTeal).opacity(0.08)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        CardBox {
                            Text("Group: \(groupName)")
                                .font(.headline)
                        }

                        CardBox {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Item Name")
                                        .font(.headline)

                                    TextField("Enter item name", text: $name)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Price ($)")
                                        .font(.headline)

                                    TextField("0.00", text: $priceText)
                                        .keyboardType(.decimalPad)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Quantity")
                                        .font(.headline)

                                    Stepper(value: $quantity, in: 1...99) {
                                        Text("\(quantity)")
                                    }
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Notes")
                                        .font(.headline)

                                    TextField("Brand / size", text: $notes)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }

                        CardBox {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Preview")
                                    .font(.headline)

                                HStack {
                                    Text("Subtotal:")
                                    Spacer()
                                    Text(previewSubtotal.moneyText)
                                }

                                HStack {
                                    Text("Tax (\(Int(taxRate))%):")
                                    Spacer()
                                    Text(previewTax.moneyText)
                                }

                                HStack {
                                    Text("Item Total:")
                                    Spacer()
                                    Text(previewTotal.moneyText)
                                }
                            }
                        }

                        if item != nil {
                            Button(action: {
                                onDelete?()
                                dismiss()
                            }) {
                                Text("Delete Item")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.red.opacity(0.4), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(item == nil ? "Add Item" : "Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(
                            name.trimmingCharacters(in: .whitespacesAndNewlines),
                            priceValue,
                            quantity,
                            notes.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || priceValue <= 0)
                }
            }
        }
    }
}
