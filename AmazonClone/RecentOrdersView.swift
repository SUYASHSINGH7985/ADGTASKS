import SwiftUI

struct RecentOrdersView: View {
    @AppStorage("orderHistory") private var orderHistoryData: Data?
    @State private var orderHistory: [Order] = []
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var orderToDelete: Order? = nil

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading orders...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if orderHistory.isEmpty {
                    emptyOrderView
                } else {
                    ordersList
                }
            }
            .navigationTitle("Your Orders")
            .toolbar {
                EditButton() // Enable swipe-to-delete
            }
            .onAppear {
                loadOrders()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .confirmationDialog("Delete Order", isPresented: Binding<Bool>(
                get: { orderToDelete != nil },
                set: { if !$0 { orderToDelete = nil } }
            )) {
                Button("Delete", role: .destructive) {
                    if let order = orderToDelete {
                        deleteOrder(order)
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    // MARK: - Subviews

    private var emptyOrderView: some View {
        VStack {
            Image(systemName: "clock.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray)
                .padding()
            Text("No recent orders")
                .font(.title2)
                .foregroundColor(.gray)
            Text("Your recent orders will appear here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var ordersList: some View {
        List {
            ForEach(orderHistory) { order in
                NavigationLink(destination: OrderDetailView(order: order)) {
                    OrderCardView(order: order)
                }
            }
            .onDelete { offsets in
                if let index = offsets.first {
                    orderToDelete = orderHistory[index]
                }
            }
        }
        .refreshable {
            loadOrders() // Pull-to-refresh
        }
    }

    // MARK: - Helper Functions

    private func loadOrders() {
        isLoading = true
        showError = false
        errorMessage = ""

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            do {
                guard let data = orderHistoryData else {
                    throw NSError(domain: "No data found", code: -1, userInfo: nil)
                }
                orderHistory = try JSONDecoder().decode([Order].self, from: data)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isLoading = false
        }
    }

    private func deleteOrder(_ order: Order) {
        withAnimation {
            orderHistory.removeAll { $0.id == order.id }
            saveOrders()
        }
    }

    private func saveOrders() {
        if let data = try? JSONEncoder().encode(orderHistory) {
            orderHistoryData = data
        }
    }
}

// MARK: - OrderCardView

struct OrderCardView: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Order #\(order.id)")
                    .font(.headline)
                Spacer()
                Text(order.status.rawValue)
                    .font(.subheadline)
                    .foregroundColor(order.status == .delivered ? .green : .orange)
            }

            Text("Placed on \(formattedDate(order.date))")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Total: ₹\(String(format: "%.2f", order.totalAmount))")
                .font(.headline)

            if !order.items.isEmpty {
                Text("Items: \(order.items.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    RecentOrdersView()
}
