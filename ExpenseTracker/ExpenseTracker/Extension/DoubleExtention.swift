
import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func oneDigit() -> String {
        return String(format: "%.1f", self)
    }
    
    func twoDigit() -> String {
        return String(format: "%.2f", self)
    }
    
    func threeDigit() -> String {
        return String(format: "%.2f", self)
    }
    
    func decimal() -> String {
        let decimal = self.truncatingRemainder(dividingBy: 1)
        return decimal > 0.009 ? String(format:"%0.2f", self) : String(Int(self))
    }
}
