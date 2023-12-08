import Foundation

public extension Int {
    var binary: String {
        String(self, radix: 2)
    }
    
    func binary(padLength: Int, with character: Character = "0") -> String {
        let binary = self.binary
        return String(repeating: character, count: padLength - binary.count) + binary
    }
    
    var isPrime: Bool {
        guard self >= 2     else { return false }
        guard self != 2     else { return true  }
        guard self % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains { self % $0 == 0 }
    }
}
