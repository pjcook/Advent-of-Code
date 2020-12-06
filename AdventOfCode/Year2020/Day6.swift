import Foundation

public struct Day6 {
    public func count(input: [String], reduce: (_ input: Array<String>.SubSequence) -> Int) -> Int {
        return input
            .split(whereSeparator: { $0.isEmpty })
            .map(reduce)
            .reduce(0) { $0 + $1 }
    }
    
    public func reduce(_ input: Array<String>.SubSequence) -> Int {
        var responses = Set<UnicodeScalar>()
        input.forEach {
            responses.formUnion($0.unicodeScalars)
        }
        return responses.count
    }
    
    public func reduce2(_ input: Array<String>.SubSequence) -> Int {
        let groupMemberCount = input.count
        var responses = [Character:Int]()
        input.forEach {
            $0.forEach {
                responses[$0] = (responses[$0] ?? 0) + 1
            }
        }
        return responses.filter { $0.value == groupMemberCount }.count
    }
}
