public extension String {
    subscript (i: Int) -> SubSequence {
        get {
            return self[i ..< i + 1]
        }
        set {
            let lower = index(startIndex, offsetBy: i)
            replaceSubrange(lower...lower, with: newValue)
        }
    }
    
    var binary: Int? {
        Int(self, radix: 2)
    }
}

public extension StringProtocol {

    var length: Int {
        return count
    }
    
    subscript (i: Int, l: Int) -> SubSequence {
        return self[i ..< i + l]
    }

    func substring(fromIndex: Int) -> SubSequence {
        return self[Swift.min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> SubSequence {
        return self[0 ..< Swift.max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> SubSequence {
        let range = Range(uncheckedBounds: (lower: Swift.max(0, Swift.min(length, r.lowerBound)),
                                            upper: Swift.min(length, Swift.max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[start ..< end]
    }
}

public enum Alphabet {
    public static let letters = "abcdefghijklmnopqrstuvwxyz"
    public static let lettersList: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    public static var Uppercased: String { letters.uppercased() }
    public static var lettersUppercasedList: [Character] { lettersList.map({ Character($0.uppercased()) }) }
}
