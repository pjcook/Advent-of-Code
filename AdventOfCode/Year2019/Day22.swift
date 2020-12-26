import Foundation

public class DeckShuffle {
    private let sizeOfDeck: Int
    
    public init(sizeOfDeck: Int) {
        self.sizeOfDeck = sizeOfDeck
    }
    
    public func process(_ input: [String]) -> Int {
        var pos = 2019
        for line in input {
            if line == "deal into new stack" {
                pos = sizeOfDeck - 1 - pos
            } else if line.hasPrefix("cut") {
                var n = line.getNumber()
                if n > 0 {
                    if pos < n {
                        pos = (sizeOfDeck-n) + pos
                    } else {
                        pos -= n
                    }
                } else {
                    n = sizeOfDeck - n
                    if pos >= n {
                        pos -= sizeOfDeck - n
                    } else {
                        pos += n
                    }
                }
            } else {
                let n = line.getNumber()
                pos = (n * pos) % sizeOfDeck
            }
        }
        return pos
    }
}

extension String {
    func getNumber() -> Int {
        return Int(components(separatedBy: " ").last!)!
    }
}
