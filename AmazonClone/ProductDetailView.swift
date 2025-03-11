import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Binding var cartItems: [Product]
    @Binding var showUSD: Bool  // Currency toggle
    @Binding var wishlist: [Product]

    let exchangeRate: Double = 83.00  // USD to INR exchange rate

    var body: some View {
        VStack {
            Image(product.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(15)
                .padding()

            Text(product.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(showUSD ? "$\(String(format: "%.2f", product.priceINR / exchangeRate))" : "₹\(String(format: "%.2f", product.priceINR))")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 5)
            
            Text(product.description)
                .font(.body)
                .padding()
                .multilineTextAlignment(.center)

            HStack {
                Button("Add to Cart") {
                    cartItems.append(product)
                }
                .buttonStyle(.borderedProminent)
                .padding()

                Button(action: {
                    if !wishlist.contains(where: { $0.id == product.id }) {
                        wishlist.append(product)
                    }
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(wishlist.contains(where: { $0.id == product.id }) ? .red : .gray)
                        .font(.title)
                }
                .padding()
            }
        }
        .navigationTitle("Product Details")
    }
}

#Preview {
    ProductDetailView(
        product: Product(name: "iPhone 16", priceINR: 69999.00, imageName: "iphone16", rating: 5, description: "The latest iPhone with A17 chip."),
        cartItems: .constant([]),
        showUSD: .constant(false),
        wishlist: .constant([])
    )
}
