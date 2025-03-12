# Amazon Clone App

This is a SwiftUI-based Amazon Clone app that replicates the core features of an e-commerce platform, including product browsing, cart management, checkout, and order history.

## File Structure

### 1. `SignupView.swift`

**Purpose:** Handles user registration.

**Implementation:**

- Users can create an account by providing their name, address, and payment details.
- Validates input fields (e.g., non-empty fields, matching passwords).
- Saves user credentials using `@AppStorage`.
- Navigates to the login screen after successful registration.

### 2. `LoginView.swift`

**Purpose:** Handles user authentication.

**Implementation:**

- Users can log in using their username and password.
- Validates credentials against saved data.
- Supports a "Continue as Guest" option for guest users.
- Uses `@AppStorage` to manage the login state (`isLoggedIn`).

### 3. `CartView.swift`

**Purpose:** Displays the user's shopping cart.

**Implementation:**

- Shows a list of products added to the cart.
- Allows users to adjust product quantities or remove items.
- Displays the total price in INR or USD (toggleable).
- Includes a "Proceed to Checkout" button that navigates to the `CheckoutView`.

### 4. `CheckoutView.swift`

**Purpose:** Handles the checkout process.

**Implementation:**

- Users can enter delivery details and select a payment method (Credit Card, Debit Card, UPI, or Cash on Delivery).
- Validates all required fields before placing an order.
- Saves the order to `@AppStorage` as part of the order history.
- Clears the cart after a successful order.

### 5. `Order.swift`

**Purpose:** Defines the `Order` model.

**Implementation:**

- Represents an order with properties like `orderID`, `items`, `totalAmount`, `date`, `status`, `paymentMethod`, and `shippingAddress`.
- Conforms to `Codable` for encoding and decoding.
- Includes enums for `OrderStatus` and `PaymentMethod`.

### 6. `Product.swift`

**Purpose:** Defines the `Product` model.

**Implementation:**

- Represents a product with properties like `name`, `priceINR`, `quantity`, `imageName`, `rating`, and `description`.
- Conforms to `Identifiable` and `Codable` for unique identification and encoding/decoding.

### 7. `ContentView.swift`

**Purpose:** Main entry point of the app.

**Implementation:**

- Manages the app's navigation flow (e.g., login, signup, cart, checkout).
- Uses `@AppStorage` to track the login state and display the appropriate view.

### 8. `MainTabView.swift`

**Purpose:** Displays the main tab bar for navigation.

**Implementation:**

- Includes tabs for Home, Cart, Orders, and Profile.
- Navigates to the respective views based on user selection.

### 9. `OrderDetailView.swift`

**Purpose:** Displays details of a specific order.

**Implementation:**

- Shows the order ID, items, total amount, date, status, and payment method.
- Allows users to view past orders from the order history.

### 10. `ProductDetailView.swift`

**Purpose:** Displays details of a specific product.

**Implementation:**

- Shows the product name, price, rating, description, and image.
- Allows users to add the product to the cart.

### 11. `ProductListView.swift`

**Purpose:** Displays a list of products.

**Implementation:**

- Fetches and displays products from a data source.
- Allows users to browse products and navigate to the `ProductDetailView`.

### 12. `ProfileView.swift`

**Purpose:** Displays the user's profile.

**Implementation:**

- Shows user details like name, address, and order history.
- Allows users to log out.

### 13. `RecentOrdersView.swift`

**Purpose:** Displays the user's recent orders.

**Implementation:**

- Fetches and displays orders from the order history.
- Allows users to view order details by navigating to the `OrderDetailView`.

## Key Features

### User Authentication:

- Users can sign up, log in, or continue as guests.
- Login state is managed using `@AppStorage`.

### Product Browsing:

- Users can browse products, view details, and add items to the cart.

### Cart Management:

- Users can view, update, or remove items from the cart.
- The total price is displayed in INR or USD.

### Checkout Process:

- Users can enter delivery details and select a payment method.
- Orders are saved to the order history.

### Order History:

- Users can view their past orders and order details.

## Demo Video

Watch the demo video of the Amazon Clone app in action: [**Amazon Clone App Demo Video**](#)

## How to Run the App

### Clone the repository:

```bash
git clone https://github.com/your-username/amazon-clone-app.git
```

### Open the project in Xcode.

### Build and run the app on a simulator or physical device.

## Dependencies

- **SwiftUI:** Used for building the user interface.
- **Foundation:** Used for basic data types and encoding/decoding.
- **@AppStorage:** Used for persistent storage of user data.

## Contributing

Contributions are welcome! If you find any issues or want to add new features, feel free to open a pull request.


