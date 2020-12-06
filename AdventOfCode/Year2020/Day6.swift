import Foundation

public struct Day6 {
    public func count(input: [String]) -> Int {
        let groups = input.split(whereSeparator: { $0.isEmpty })
        let groupedResponses: [[Character:Bool]] = groups.map {
            var responses = [Character:Bool]()
            $0.forEach {
                $0.forEach { responses[$0] = true }
            }
            return responses
        }
        
        return groupedResponses.map { $0.count }
            .reduce(0) { $0 + $1 }
    }
    
    public func count2(input: [String]) -> Int {
        let groups = input.split(whereSeparator: { $0.isEmpty })
        let groupedResponses: [[Character:Int]] = groups.map {
            let groupMemberCount = $0.count
            var responses = [Character:Int]()
            $0.forEach {
                $0.forEach {
                    responses[$0] = (responses[$0] ?? 0) + 1
                }
            }
            return responses.filter { $0.value == groupMemberCount }
        }
        
        return groupedResponses.map { $0.count }
            .reduce(0) { $0 + $1 }
    }
}
