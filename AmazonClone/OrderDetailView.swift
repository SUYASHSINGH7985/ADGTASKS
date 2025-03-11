import SwiftUI

struct OrderDetailView: View {
    var order: Order  // ✅ The selected order

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Order Summary
                VStack(alignment: .leading, spacing: 10) {
                    Text("Order #\(order.id)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    HStack {
                        Text("Status:")
                            .font(.headline)
                        Text(order.status.rawValue)
                            .font(.subheadline)
                            .foregroundColor(order.status == .delivered ? .green : .orange)
                    }

                    Text("Placed on \(formattedDate(order.date))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Total: ₹\(String(format: "%.2f", order.totalAmount))")
                        .font(.title2)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                // Payment Method
                VStack(alignment: .leading, spacing: 10) {
                    Text("Payment Method")
                        .font(.headline)
                    Text(order.paymentMethod.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                // Shipping Address
                VStack(alignment: .leading, spacing: 10) {
                    Text("Shipping Address")
                        .font(.headline)
                    Text(order.shippingAddress)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                // Items List
                VStack(alignment: .leading, spacing: 10) {
                    Text("Items (\(order.items.count))")
                        .font(.headline)

                    ForEach(order.items) { item in
                        HStack {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)

                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)

                                Text("₹\(String(format: "%.2f", item.priceINR))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text("Quantity: \(item.quantity)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding()
        }
        .navigationTitle("Order Details")
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
