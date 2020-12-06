import Foundation

public struct Day6 {
    public func count(input: [String]) -> Int {
        return input.split(whereSeparator: { $0.isEmpty })
            .map(reduce)
            .map { $0.count }
            .reduce(0) { $0 + $1 }
    }
    
    public func reduce(_ input: Array<String>.SubSequence) -> [Character : Bool] {
        var responses = [Character:Bool]()
        input.forEach {
            $0.forEach { responses[$0] = true }
        }
        return responses
    }
    
    public func count2(input: [String]) -> Int {
        return input.split(whereSeparator: { $0.isEmpty })
            .map(reduce2)
            .map { $0.count }
            .reduce(0) { $0 + $1 }
    }
    
    public func reduce2(_ input: Array<String>.SubSequence) -> [Character: Int] {
        let groupMemberCount = input.count
        var responses = [Character:Int]()
        input.forEach {
            $0.forEach {
                responses[$0] = (responses[$0] ?? 0) + 1
            }
        }
        return responses.filter { $0.value == groupMemberCount }
    }
}
