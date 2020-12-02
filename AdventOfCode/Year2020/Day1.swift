import Foundation

public enum Day1 {
    public static func findMatch(input: [Int], value: Int) -> Int {
        var pt1 = 0
        
        while pt1 < input.count-1 {
            var pt2 = pt1 + 1
            while pt2 < input.count {
                if input[pt1] + input[pt2] == value {
                    return input[pt1] * input[pt2]
                }
                pt2 += 1
            }
            pt1 += 1
        }
        
        return 0
    }
    
    public static func findMatch2(input: [Int], value: Int) -> Int {
        var pt1 = 0
        
        while pt1 < input.count-1 {
            var pt2 = pt1 + 1
            while pt2 < input.count {
                var pt3 = pt2 + 1
                while pt3 < input.count {
                    if input[pt1] + input[pt2] + input[pt3] == value {
                        return input[pt1] * input[pt2] * input[pt3]
                    }
                    pt3 += 1
                }
                pt2 += 1
            }
            pt1 += 1
        }
        
        return 0
    }
    
    public static func findMatch3(input: [Int], value: Int) -> Int {
        let values = Set(input)
        return input
            .first(where: { values.contains(value - $0) })
            .map { $0 * (value - $0) } ?? 0
    }
    
    public static func findMatch4(input: [Int], value: Int) -> Int {
        let dict = input.reduce(into: [Int:Int]()) { $0[$1] = 0 }
        return input
            .first(where: { dict[value - $0] != nil })
            .map { $0 * (value - $0) } ?? 0
    }
    
    public static func findMatch(input: [Int], matchValue: Int, levels: Int, startIndex: Int = 0, currentValue: Int = 0, level: Int = 1, indexes: [Int] = [], match: (Int, Int) -> Int, output: (Int, Int) -> Int) -> Int {
        var pt = startIndex
        while pt < input.count {
            if level == levels {
                if match(input[pt], currentValue) == matchValue {
                    var values = [Int]()
                    indexes.forEach { values.append(input[$0]) }
                    values.append(input[pt])
                    return values.reduce(1, output)
                }
            } else {
                let result = findMatch(input: input, matchValue: matchValue, levels: levels, startIndex: pt+1, currentValue: currentValue + input[pt], level: level + 1, indexes: indexes + [pt], match: match, output: output)
                guard result == -1 else { return result }
            }
            
            pt += 1
        }
        return -1
    }
}
