import Foundation  // ✅ Ensure UUID and Codable are available

struct Product: Identifiable, Codable {
    let id: UUID  // ✅ Define id without default value
    let name: String
    let priceINR: Double
    var quantity: Int  // ✅ No default value here
    let imageName: String
    let rating: Int
    let description: String

    // ✅ Custom initializer to set default values
    init(id: UUID = UUID(), name: String, priceINR: Double, quantity: Int = 1, imageName: String, rating: Int, description: String) {
        self.id = id
        self.name = name
        self.priceINR = priceINR
        self.quantity = quantity
        self.imageName = imageName
        self.rating = rating
        self.description = description
    }
}
