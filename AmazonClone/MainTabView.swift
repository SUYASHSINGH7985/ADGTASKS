import SwiftUI

struct MainTabView: View {
    @Binding var cartItems: [Product]
    @Binding var wishlist: [Product]
    @Binding var showUSD: Bool

    var body: some View {
        TabView {
            ProductListView(cartItems: $cartItems, wishlist: $wishlist, showUSD: $showUSD)
                .tabItem {
                    Label("Products", systemImage: "list.dash")
                }

            CartView(cartItems: $cartItems, wishlist: $wishlist, showUSD: $showUSD)
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
                .badge(cartItems.count)

            OrderHistoryView()
                .tabItem {
                    Label("Orders", systemImage: "clock.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MainTabView(cartItems: .constant([Product(name: "Sample Product", priceINR: 2999, imageName: "sample", rating: 4, description: "Sample product description")]),
                wishlist: .constant([Product(name: "Wishlist Item", priceINR: 1599, imageName: "wishlist", rating: 5, description: "Wishlist product description")]),
                showUSD: .constant(true))
}
