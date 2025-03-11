import Foundation

struct Order: Identifiable, Codable {
    let id: UUID  // ✅ Remove default value to allow decoding
    let orderID: String
    let items: [Product]
    let totalAmount: Double
    let date: Date
    let status: Status
    let paymentMethod: PaymentMethod
    let shippingAddress: String

    enum Status: String, Codable {
        case pending = "Pending"
        case shipped = "Shipped"
        case delivered = "Delivered"
        case cancelled = "Cancelled"
    }

    enum PaymentMethod: String, Codable {
        case creditCard = "Credit Card"
        case debitCard = "Debit Card"
        case upi = "UPI"
        case cashOnDelivery = "Cash on Delivery"
    }

    // ✅ Custom initializer to assign a default UUID if needed
    init(id: UUID = UUID(), orderID: String, items: [Product], totalAmount: Double, date: Date, status: Status, paymentMethod: PaymentMethod, shippingAddress: String) {
        self.id = id
        self.orderID = orderID
        self.items = items
        self.totalAmount = totalAmount
        self.date = date
        self.status = status
        self.paymentMethod = paymentMethod
        self.shippingAddress = shippingAddress
    }
}
