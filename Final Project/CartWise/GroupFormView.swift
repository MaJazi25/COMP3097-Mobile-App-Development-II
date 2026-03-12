import SwiftUI

struct GroupFormView: View {
    @EnvironmentObject var router: AppRouter

    var group: ShoppingGroup?
    var onSave: (String, Double) -> Void
    var onDelete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var taxRate: Double

    init(group: ShoppingGroup? = nil, onSave: @escaping (String, Double) -> Void, onDelete: (() -> Void)? = nil) {
        self.group = group
        self.onSave = onSave
        self.onDelete = onDelete
        _name = State(initialValue: group?.name ?? "")
        _taxRate = State(initialValue: group?.taxRate ?? 0)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemTeal).opacity(0.08)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    CardBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Group Name")
                                .font(.headline)

                            TextField("Enter group name", text: $name)
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                    CardBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tax Rate")
                                .font(.headline)

                            Picker("Tax Rate", selection: $taxRate) {
                                Text("0%").tag(0.0)
                                Text("13%").tag(13.0)
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    if group != nil {
                        Button(action: {
                            onDelete?()
                            dismiss()
                        }) {
                            Text("Delete Group")
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

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(group == nil ? "Add Group" : "Edit Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Home") {
                        dismiss()
                        router.goHome()
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(name.trimmingCharacters(in: .whitespacesAndNewlines), taxRate)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
