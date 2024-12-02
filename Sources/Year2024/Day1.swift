import Foundation
import StandardLibraries

public struct Day1 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var sum = 0
        let (list1, list2) = extractNumbers(input)
        
        for items in zip(list1, list2) {
            sum += abs(items.0 - items.1)
        }

        return sum
    }
    
    public func part2(_ input: [String]) -> Int {
        var checked = [Int: Int]()
        var sum = 0
        let (list1, list2) = extractNumbers(input)
        
        for item in list1 {
            if let answer = checked[item] {
                sum += answer
                continue
            }
            
            let answer = item * list2.filter({ $0 == item }).count
            checked[item] = answer
            sum += answer
        }
        
        return sum
    }
}

extension Day1 {
    public func extractNumbers(_ input: [String]) -> ([Int],[Int]) {
        var list1 = [Int]()
        var list2 = [Int]()
                     
        
        for line in input {
            let components = line.components(separatedBy: "   ").map({ Int($0)! })
            list1.append(components.first!)
            list2.append(components.last!)
        }
        
        return (list1.sorted(), list2.sorted())
    }
}
