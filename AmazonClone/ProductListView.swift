import SwiftUI

struct ProductListView: View {
    @Binding var cartItems: [Product]
    @Binding var wishlist: [Product]  // Add this line to fix missing wishlist
    @Binding var showUSD: Bool
    
    @State private var products: [Product] = [
        Product(name: "iPhone 16", priceINR: 69999, imageName: "iphone16", rating: 5, description: "The latest iPhone with A17 chip."),
        Product(name: "iPhone 16 Pro", priceINR: 119000, imageName: "iphone16pro", rating: 5, description: "Premium flagship with advanced camera."),
        Product(name: "iPhone 16 Pro Max", priceINR: 144900, imageName: "iphone16promax", rating: 5, description: "Best of the best."),
        Product(name: "MacBook Pro M3", priceINR: 239000, imageName: "macbookpro3", rating: 4, description: "Powerful laptop for professionals."),
        Product(name: "AirPods Pro 2", priceINR: 24900, imageName: "airpods", rating: 5, description: "Noise-cancelling wireless earbuds."),
        Product(name: "Apple Watch Series 9", priceINR: 41900, imageName: "applewatch", rating: 4, description: "Stay connected and healthy."),
        Product(name: "iPad Pro M2", priceINR: 128000, imageName: "ipadprom2", rating: 5, description: "A powerful tablet for work and creativity."),
        Product(name: "HomePod (2nd Gen)", priceINR: 32900, imageName: "homepods", rating: 4, description: "Smart speaker with spatial audio."),
        Product(name: "Apple TV 4K", priceINR: 14900, imageName: "appletv4k", rating: 4, description: "Streaming device with high-quality visuals."),
        Product(name: "Apple Vision Pro", priceINR: 299999, imageName: "applevisionpro", rating: 5, description: "A revolutionary AR/VR headset.")
    ]
    @State private var searchText = ""
        @State private var sortOption: SortOption = .none
        
        enum SortOption {
            case none, lowToHigh, highToLow
        }

        var filteredProducts: [Product] {
            var result = products
            if !searchText.isEmpty {
                result = result.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }
            switch sortOption {
            case .lowToHigh:
                result.sort { $0.priceINR < $1.priceINR }
            case .highToLow:
                result.sort { $0.priceINR > $1.priceINR }
            case .none:
                break
            }
            return result
        }

    var body: some View {
        NavigationView {
            List(products) { product in
                HStack {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text(product.name)
                            .font(.headline)
                        Text("₹\(String(format: "%.2f", product.priceINR))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        cartItems.append(product)  // ✅ Add item to cart
                    }) {
                        Image(systemName: "cart.badge.plus")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Products")
        }
    }
}
