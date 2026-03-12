import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var store: CartWiseStore
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {
            Color(.systemTeal).opacity(0.08)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    CardBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Overall Totals")
                                .font(.headline)

                            HStack {
                                Text("Subtotal:")
                                Spacer()
                                Text(store.overallSubtotal.moneyText)
                            }

                            HStack {
                                Text("Total Tax:")
                                Spacer()
                                Text(store.overallTax.moneyText)
                            }

                            HStack {
                                Text("Grand Total:")
                                Spacer()
                                Text(store.overallTotal.moneyText)
                                    .bold()
                            }
                        }
                    }

                    CardBox {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Breakdown by Group")
                                .font(.headline)

                            ForEach(store.groups) { group in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(group.name)
                                        .font(.headline)

                                    Text("Subtotal: \(group.subtotal.moneyText)")
                                    Text("Tax: \(group.taxAmount.moneyText)")
                                    Text("Total: \(group.total.moneyText)")
                                }

                                if group.id != store.groups.last?.id {
                                    Divider()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Home") {
                    router.goHome()
                }
            }
        }
    }
}
