import SwiftUI

struct CartView: View {
    @Binding var cartItems: [Product]
    @Binding var wishlist: [Product]
    @Binding var showUSD: Bool
    let exchangeRate: Double = 87.00

    var totalPrice: Double {
        let total = cartItems.reduce(0) { $0 + ($1.priceINR * Double($1.quantity)) }
        return total.isFinite && total > 0 ? total : 0.0
    }

    var totalPriceUSD: Double {
        let rate = exchangeRate > 0 ? exchangeRate : 1
        let convertedPrice = totalPrice / rate
        return convertedPrice.isFinite ? convertedPrice : 0.0
    }


    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Show Prices in USD")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Toggle("", isOn: $showUSD)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)

                if cartItems.isEmpty {
                    VStack {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                            .padding()
                        Text("Your cart is empty")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach($cartItems) { $item in
                            HStack {
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                        .lineLimit(2)

                                    if showUSD {
                                        Text("$\(String(format: "%.2f", (item.priceINR / exchangeRate).isFinite ? (item.priceINR / exchangeRate) : 0.0))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text(item.priceINR.formattedAsINR())
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    Stepper(value: $item.quantity, in: 1...10) {
                                        Text("Qty: \(item.quantity)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }

                                Spacer()

                                Button(action: { removeItem(item) }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .onDelete(perform: removeItems)

                        HStack {
                            Text("Total:")
                                .font(.headline)
                            Spacer()
                            if showUSD {
                                Text("$\(String(format: "%.2f", totalPriceUSD))")
                                    .font(.headline)
                            } else {
                                Text(totalPrice.formattedAsINR())
                                    .font(.headline)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listStyle(PlainListStyle())
                }

                if !cartItems.isEmpty {
                    NavigationLink(destination: CheckoutView(cartItems: $cartItems)) {
                        Text("Proceed to Checkout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                EditButton()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func removeItem(_ product: Product) {
        withAnimation {
            if let index = cartItems.firstIndex(where: { $0.id == product.id }) {
                cartItems.remove(at: index)
            }
        }
    }

    func removeItems(at offsets: IndexSet) {
        withAnimation {
            cartItems.remove(atOffsets: offsets)
        }
    }
}

#Preview {
    CartView(
        cartItems: .constant([
            Product(name: "Sample Item 1", priceINR: 199000.0, quantity: 2, imageName: "sample1", rating: 4, description: "Sample description 1"),
            Product(name: "Sample Item 2", priceINR: 200.0, quantity: 1, imageName: "sample2", rating: 5, description: "Sample description 2")
        ]),
        wishlist: .constant([]),
        showUSD: .constant(false)
    )
}
