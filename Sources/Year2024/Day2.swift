import Foundation
import StandardLibraries

public struct Day2 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let results = parse(input)
        var sum = 0
        
        for result in results {
            sum += isValidSequence(result, hasFaultTolerance: false) ? 1 : 0
        }
        
        return sum
    }
    
    public func part2(_ input: [String]) -> Int {
        let results = parse(input)
        var sum = 0
        
        for result in results {
            sum += isValidSequence(result, hasFaultTolerance: true) ? 1 : 0
        }
        
        return sum
    }
}

extension Day2 {
    public func part2_validation(_ input: [String], _ input2: [String]) -> Int {
        let results = parse(input)
        let results2 = parse(input2)
        var sum = 0
        
        for item in results {
            let result = isValidSequence(item, hasFaultTolerance: true)
            if !result,
                results2.contains(item) {
                print(item)
            }
            sum += result ? 1 : 0
        }
        
        return sum
    }
    
    enum Direction {
        case unknown, up, down
    }
    
    func checkFaultTolerance(_ list: [Int], index: Int) -> Bool {
        var list1 = list
        var list2 = list
        list1.remove(at: index-1)
        list2.remove(at: index)
        if isValidSequence(list1, hasFaultTolerance: false) {
            return true
        }
        if list1 != list2, isValidSequence(list2, hasFaultTolerance: false) {
            return true
        }
        
        for i in (0..<list.count) {
            var list3 = list
            list3.remove(at: i)
            if isValidSequence(list3, hasFaultTolerance: false) {
                return true
            }
        }
        
        return false
    }
    
    public func isValidSequence(_ list: [Int], hasFaultTolerance: Bool) -> Bool {
        var direction: Direction = .unknown
        var last = list.first!
        var failed = false
        
        for i in (1...list.count-1) {
            let value = list[i]
            if direction == .unknown {
                if last < value {
                    direction = .up
                } else {
                    direction = .down
                }
            }
            
            if !(1...3).contains(abs(last - value)) {
                if hasFaultTolerance, checkFaultTolerance(list, index: i) {
                    return true
                }
                failed = true
                break
            }
            
            switch direction {
            case .up:
                if last < value {
                    last = value
                    continue
                }
            case .down:
                if last > value {
                    last = value
                    continue
                }
            default:
                break
            }
            
            if hasFaultTolerance, checkFaultTolerance(list, index: i) {
                return true
            }

            failed = true
            break
        }
        
        return !failed
    }
    
    func parse(_ input: [String]) -> [[Int]] {
        var results = [[Int]]()
        
        for line in input {
            let components = line.components(separatedBy: " ").map({ Int($0)! })
            results.append(components)
        }
        
        return results
    }
}
