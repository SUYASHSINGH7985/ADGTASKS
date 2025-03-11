// Extensions.swift
import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func formattedAsINR() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_IN")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedString = formatter.string(from: NSNumber(value: self)) {
            return "₹\(formattedString)"
        }
        return "₹\(String(format: "%.2f", self))"
    }
}
