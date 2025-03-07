import Foundation

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let description: String
}
