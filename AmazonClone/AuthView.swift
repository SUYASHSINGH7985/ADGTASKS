import SwiftUI

struct AuthView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var isShowingLogin = false
    @State private var isShowingSignup = false
    @State private var isGuestAccess = false

    // Cart items state
    @State private var cartItems: [Product] = []
    @State private var wishlist: [Product] = []  // Wishlist state
    @State private var showUSD = false  // Currency toggle state

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn || isGuestAccess {
                    MainTabView(cartItems: $cartItems, wishlist: $wishlist, showUSD: $showUSD)
                        .environment(\.isGuestAccess, isGuestAccess) // Pass guest status to child views
                } else {
                    VStack(spacing: 20) {
                        Button(action: {
                            isShowingLogin = true
                        }) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            isShowingSignup = true
                        }) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            isGuestAccess = true
                        }) {
                            Text("Continue as Guest")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $isShowingLogin) {
                LoginView(isLoggedIn: $isLoggedIn, isShowingLogin: $isShowingLogin)
            }
            .sheet(isPresented: $isShowingSignup) {
                SignupView(isLoggedIn: $isLoggedIn, isShowingSignup: $isShowingSignup)
            }
        }
    }
}

// Custom Environment Key to pass guest status
struct GuestAccessKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isGuestAccess: Bool {
        get { self[GuestAccessKey.self] }
        set { self[GuestAccessKey.self] = newValue }
    }
}

#Preview {
    AuthView()
}
