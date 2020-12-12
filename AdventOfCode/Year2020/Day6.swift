import Foundation

public struct Day6 {
    public init() {}
    
    public static func count(input: [String], reduce: (_ input: Array<String>.SubSequence) -> Int) -> Int {
        return input
            .split(whereSeparator: { $0.isEmpty })
            .map(reduce)
            .reduce(0, +)
    }
    
    public static func reduce_part1(_ input: Array<String>.SubSequence) -> Int {
        var responses = Set<UnicodeScalar>()
        input.forEach { responses.formUnion($0.unicodeScalars) }
        return responses.count
    }
    
    public static func reduce_part1_v2(_ input: Array<String>.SubSequence) -> Int {
        Set(input.joined(separator: "")).count
    }

    public static func reduce_part1_v3(_ input: Array<String>.SubSequence) -> Int {
        input.reduce(into: Set<UnicodeScalar>()) { $0.formUnion($1.unicodeScalars) }.count
    }
    
    public static func reduce_part2(_ input: Array<String>.SubSequence) -> Int {
        let groupMemberCount = input.count
        var responses = [UnicodeScalar:Int]()
        input.forEach {
            $0.unicodeScalars.forEach {
                responses[$0] = (responses[$0] ?? 0) + 1
            }
        }
        return responses
            .filter { $0.value == groupMemberCount }
            .count
    }
    
    public static func reduce_part2_v2(_ input: Array<String>.SubSequence) -> Int {
        let groupMemberCount = input.count
        var responses = [UnicodeScalar:Int]()
        input
            .joined(separator: "")
            .unicodeScalars.forEach { responses[$0] = (responses[$0] ?? 0) + 1 }
            
        return responses
            .filter { $0.value == groupMemberCount }
            .count
    }
        
    public static func part1_daniel(input: [String]) -> Int {
        input
            .split(separator: "")
            .map { $0.joined(separator: "") }
            .map { Set($0).count }
            .reduce(0, +)
    }
    
    public static func part2_daniel(input: [String]) -> Int {
        input
            .split(separator: "")
            .map { group in
                let head = Set(group.first!)
                let tail = group.dropFirst().map(Set.init)
                return tail.reduce(head) { $0.intersection($1) }.count
            }
            .reduce(0, +)
    }
}
