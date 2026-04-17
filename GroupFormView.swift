import SwiftUI

struct GroupFormView: View {
    @EnvironmentObject var store: CartWiseStore
    @EnvironmentObject var router: AppRouter

    var group: ShoppingGroup?
    var onSave: (String, Double) -> Void
    var onDelete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var taxRate: Double
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    @State private var showDeleteConfirmation = false

    init(group: ShoppingGroup? = nil, onSave: @escaping (String, Double) -> Void, onDelete: (() -> Void)? = nil) {
        self.group = group
        self.onSave = onSave
        self.onDelete = onDelete
        _name = State(initialValue: group?.name ?? "")
        _taxRate = State(initialValue: group?.taxRate ?? 0)
    }

    func saveGroup() {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        if cleanName.isEmpty {
            validationMessage = "Group name cannot be empty."
            showValidationAlert = true
            return
        }

        let duplicateExists = store.groups.contains { existingGroup in
            let sameName = existingGroup.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == cleanName.lowercased()

            if let currentGroup = group {
                return sameName && existingGroup.id != currentGroup.id
            }

            return sameName
        }

        if duplicateExists {
            validationMessage = "This group name already exists."
            showValidationAlert = true
            return
        }

        onSave(cleanName, taxRate)
        dismiss()
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
                            showDeleteConfirmation = true
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
                        saveGroup()
                    }
                }
            }
            .alert("Error", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
            .alert("Delete Group?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }

                Button("Delete", role: .destructive) {
                    onDelete?()
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this group?")
            }
        }
    }
}
