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
    
    func hammingDistance(with other: String) -> Int {
        var count = 0
        for (a,b) in zip(self,other) {
            count += a == b ? 0 : 1
        }
        return count
    }

    func chunked(size: Int) -> [String] {
        precondition(size > 0)
        precondition(count % size == 0)
        guard !isEmpty else { return [] }
        var output = [String]()
        var i = 0

        while i * size < count {
            let lower = index(startIndex, offsetBy: i * size)
            let upper = index(startIndex, offsetBy: i * size + size)
            let value = String(self[lower ..< upper])
            output.append(value)
            i += 1
        }

        return output
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
    
    subscript (r: ClosedRange<Int>) -> SubSequence {
        let range = Range(uncheckedBounds: (lower: Swift.max(0, Swift.min(length, r.lowerBound)),
                                            upper: Swift.min(length, Swift.max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[start ... end]
    }
    
    func pad(to length: Int, with character: Character = "0") -> String {
        return String(repeating: character, count: length - self.count) + self
    }
}

public enum Alphabet {
    public static let letters = "abcdefghijklmnopqrstuvwxyz"
    public static let lettersList: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    public static var Uppercased: String { letters.uppercased() }
    public static var lettersUppercasedList: [Character] { lettersList.map({ Character($0.uppercased()) }) }
}

public extension String {
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                break
            }
            position = index(after: after)
        }
        return indices
    }
    
    func ranges(of searchString: String) -> [Range<String.Index>] {
        let _indices = indices(of: searchString)
        let count = searchString.count
        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
    }
    
    func knotHash() -> String {
        let lengths = (self.map { $0.asciiValue! } + [17, 31, 73, 47, 23]).compactMap(Int.init)
        
        var skipSize = 0
        var i = 0
        var list = Array(0...255)

        for _ in 0..<64 {
            for l in lengths {
                if i + l < list.count {
                    list.replaceSubrange(i..<i+l, with: list[i..<i+l].reversed())
                } else {
                    let remainder = l + i - list.count
                    let reversed = Array(Array(list[i...] + list[..<remainder]).reversed())
                    let remainderIndex = (reversed.count - remainder)
                    list.replaceSubrange(i..., with: reversed[..<remainderIndex])
                    list.replaceSubrange(..<remainder, with: reversed[remainderIndex...])
                }
                i += skipSize + l
                i = i % list.count
                skipSize += 1
            }
        }
        
        var denseHash = [Int]()
        i = 0
        var subset = [Int]()
        while i < list.count {
            subset.append(list[i])
            i += 1
            if i % 16 == 0 {
                denseHash.append(subset[1...].reduce(subset[0], { $0 ^ $1 }))
                subset = []
            }
        }
        
        return denseHash.map({ String($0, radix: 16).pad(to: 2) }).joined()
    }
}
