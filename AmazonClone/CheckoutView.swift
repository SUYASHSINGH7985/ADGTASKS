import SwiftUI
import Foundation

struct CheckoutView: View {
    @Binding var cartItems: [Product]
    @AppStorage("orderHistory") private var orderHistoryData: Data?
    @State private var name = ""
    @State private var address = ""
    @State private var paymentMethod = "Credit Card"
    let paymentOptions = ["Credit Card", "Debit Card", "UPI", "Cash on Delivery"]

    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var upiID = ""

    @State private var showValidationErrors = false
    @State private var showConfirmation = false
    @State private var confirmedOrder: Order?

    @State private var selectedCurrency: String = "INR"
    let currencies = ["INR", "USD", "CAD"]
    @State private var exchangeRates: [String: Double] = [
        "INR": 1.0,
        "USD": 0.012,
        "CAD": 0.016
    ]

    var totalPrice: Double {
        let totalINR = cartItems.reduce(0) { $0 + ($1.priceINR * Double($1.quantity)) }
        let exchangeRate = exchangeRates[selectedCurrency] ?? 1.0
        return (totalINR * exchangeRate).rounded(toPlaces: 2)
    }

    var body: some View {
        NavigationView {
            if showConfirmation, let order = confirmedOrder {
                OrderConfirmationView(order: order, onContinue: {
                    cartItems.removeAll()
                    showConfirmation = false
                })
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        deliveryDetailsSection
                        paymentMethodSection
                        currencyPickerSection
                        totalPriceSection
                        confirmOrderButton
                    }
                    .padding()
                }
                .navigationTitle("Checkout")
                .alert(isPresented: $showValidationErrors) {
                    Alert(
                        title: Text("Validation Error"),
                        message: Text("Please fill in all required fields: Name, Address, and payment details."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var deliveryDetailsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Delivery Details")
                .font(.headline)
                .foregroundColor(.gray)

            TextField("Full Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 8)

            TextField("Delivery Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Payment Method")
                .font(.headline)
                .foregroundColor(.gray)

            Picker("Payment Method", selection: $paymentMethod) {
                ForEach(paymentOptions, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

            if paymentMethod == "Credit Card" || paymentMethod == "Debit Card" {
                TextField("Card Number", text: $cardNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.vertical, 8)

                TextField("Expiry Date (MM/YY)", text: $expiryDate)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.vertical, 8)

                SecureField("CVV", text: $cvv)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.vertical, 8)
            } else if paymentMethod == "UPI" {
                TextField("Enter UPI ID", text: $upiID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var currencyPickerSection: some View {
        HStack {
            Text("Currency:")
                .font(.headline)
            Picker("Currency", selection: $selectedCurrency) {
                ForEach(currencies, id: \.self) { currency in
                    Text(currency)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
    }

    private var totalPriceSection: some View {
        HStack {
            Text("Total:")
                .font(.title2)
            Spacer()
            Text(selectedCurrency == "INR" ? totalPrice.formattedAsINR() : "\(selectedCurrency) \(String(format: "%.2f", totalPrice))")
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var confirmOrderButton: some View {
        Button(action: {
            print("Confirm Order button tapped")
            confirmOrder()
        }) {
            Text("Confirm Order")
                .frame(maxWidth: .infinity)
                .padding()
                .background(isValidOrder() ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(!isValidOrder())
        .padding()
    }

    private func confirmOrder() {
        print("confirmOrder() called")
        if isValidOrder() {
            print("Order is valid, proceeding to place order")
            let paymentMethodEnum: Order.PaymentMethod
            switch paymentMethod {
            case "Credit Card":
                paymentMethodEnum = .creditCard
            case "Debit Card":
                paymentMethodEnum = .debitCard
            case "UPI":
                paymentMethodEnum = .upi
            case "Cash on Delivery":
                paymentMethodEnum = .cashOnDelivery
            default:
                paymentMethodEnum = .creditCard
            }

            let newOrder = Order(
                orderID: "ORD\(Int.random(in: 100000...999999))",
                items: cartItems,
                totalAmount: totalPrice,
                date: Date(),
                status: .pending,
                paymentMethod: paymentMethodEnum,
                shippingAddress: address
            )

            saveOrder(newOrder)
            confirmedOrder = newOrder
            showConfirmation = true
        } else {
            print("Order validation failed")
            showValidationErrors = true
        }
    }

    private func isValidOrder() -> Bool {
        print("Validating order:")
        print("Name: \(name.isEmpty ? "empty" : "filled")")
        print("Address: \(address.isEmpty ? "empty" : "filled")")
        if paymentMethod == "Credit Card" || paymentMethod == "Debit Card" {
            print("Card Number: \(cardNumber.isEmpty ? "empty" : "filled")")
            print("Expiry Date: \(expiryDate.isEmpty ? "empty" : "filled")")
            print("CVV: \(cvv.isEmpty ? "empty" : "filled")")
        } else if paymentMethod == "UPI" {
            print("UPI ID: \(upiID.isEmpty ? "empty" : "filled")")
        }

        if name.isEmpty || address.isEmpty {
            print("Validation failed: Name or Address is empty")
            return false
        }

        switch paymentMethod {
        case "Credit Card", "Debit Card":
            let isValid = !cardNumber.isEmpty && !expiryDate.isEmpty && !cvv.isEmpty
            print("Payment validation for \(paymentMethod): \(isValid ? "valid" : "invalid")")
            return isValid
        case "UPI":
            let isValid = !upiID.isEmpty
            print("Payment validation for UPI: \(isValid ? "valid" : "invalid")")
            return isValid
        case "Cash on Delivery":
            print("Payment validation for Cash on Delivery: valid")
            return true
        default:
            print("Validation failed: Unknown payment method")
            return false
        }
    }

    private func saveOrder(_ order: Order) {
        print("saveOrder() called")
        var orders = loadOrders()
        orders.append(order)

        if let data = try? JSONEncoder().encode(orders) {
            print("Order encoded successfully, saving to AppStorage")
            orderHistoryData = data
            print("Order saved successfully!")
        } else {
            print("Failed to encode order data.")
        }
    }

    private func loadOrders() -> [Order] {
        print("loadOrders() called")
        guard let data = orderHistoryData else {
            print("No order history data found.")
            return []
        }
        if let orders = try? JSONDecoder().decode([Order].self, from: data) {
            print("Orders loaded successfully: \(orders)")
            return orders
        } else {
            print("Failed to decode order data.")
            return []
        }
    }
}

struct OrderConfirmationView: View {
    let order: Order
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)

            Text("Thanks for your order!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("We've received your order and will process it soon.")
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 10) {
                Text("Order Details")
                    .font(.headline)

                Text("Order ID: \(order.orderID)")
                    .font(.subheadline)

                Text("Total: \(order.totalAmount.formattedAsINR())")
                    .font(.subheadline)

                Text("Shipping to: \(order.shippingAddress)")
                    .font(.subheadline)

                Text("Payment Method: \(order.paymentMethod.rawValue)")
                    .font(.subheadline)

                Text("Items:")
                    .font(.subheadline)
                ForEach(order.items) { item in
                    Text("- \(item.name) (\(item.quantity)) @ \(item.priceINR.formattedAsINR())")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            Spacer()

            Button(action: {
                onContinue()
            }) {
                Text("Continue Shopping")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Order Confirmed")
    }
}

struct OrderHistoryView: View {
    @AppStorage("orderHistory") private var orderHistoryData: Data?

    private func loadOrders() -> [Order] {
        guard let data = orderHistoryData else {
            return []
        }
        if let orders = try? JSONDecoder().decode([Order].self, from: data) {
            return orders
        }
        return []
    }

    var body: some View {
        NavigationView {
            let orders = loadOrders()
            if orders.isEmpty {
                VStack {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No orders yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            } else {
                List(orders.reversed()) { order in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Order ID: \(order.orderID)")
                            .font(.headline)
                        Text("Date: \(order.date, style: .date))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Total: \(order.totalAmount.formattedAsINR())")
                            .font(.subheadline)
                        Text("Status: \(order.status.rawValue)")
                            .font(.subheadline)
                            .foregroundColor(order.status == .pending ? .orange : .green)
                        Text("Items: \(order.items.map { "\($0.name) (\($0.quantity))" }.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
                .navigationTitle("Order History")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    CheckoutView(cartItems: .constant([
        Product(name: "Sample Item", priceINR: 199000.0, quantity: 1, imageName: "sample", rating: 4, description: "Sample description")
    ]))
}
