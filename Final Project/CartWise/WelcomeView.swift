import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Color(.systemTeal).opacity(0.08)
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 32)
                .fill(Color.blue.opacity(0.18))
                .frame(width: 320, height: 560)
                .overlay(
                    VStack(spacing: 22) {
                        Spacer()

                        Text("CartWise")
                            .font(.system(size: 32, weight: .semibold))

                        Text("Shopping List + Tax Calculator")
                            .font(.headline)

                        Text("Group G-22")
                            .font(.title3)
                            .bold()
                            .padding(.top, 10)

                        Spacer()

                        VStack(spacing: 6) {
                            Text("Mehdi Jazi")
                            Text("Student ID: 101449183")
                            Text("Adel Alhajhussain")
                            Text("Student ID: 101532466")
                        }
                        .font(.subheadline)

                        Spacer()
                    }
                    .padding()
                )
        }
    }
}
