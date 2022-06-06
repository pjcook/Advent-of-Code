import Foundation

public extension Int {
    var binary: String {
        String(self, radix: 2)
    }
    
    func binary(padLength: Int, with character: Character = "0") -> String {
        let binary = self.binary
        return String(repeating: character, count: padLength - binary.count) + binary
    }
}
