import Foundation
import StandardLibraries

public struct Day23 {
    public init() {}
    
    public func part1(_ input: [Int], turns: Int = 100) -> Int {
        var input = input
        var index = 0
        
        for _ in 0..<turns {
//            let before = input
            let current = input[index]
            var destination = input[index] - 1
            
            let next = input[findIndex(start: index, increment: 4, valueCount: input.count)]
            let one = input.remove(at: findIndex(start: input.firstIndex(of: current)!, increment: 1, valueCount: input.count))
            let two = input.remove(at: findIndex(start: input.firstIndex(of: current)!, increment: 1, valueCount: input.count))
            let three = input.remove(at: findIndex(start: input.firstIndex(of: current)!, increment: 1, valueCount: input.count))

            var insertIndex = 0
            while true {
                if let index = input.firstIndex(of: destination) {
                    insertIndex = index
                    break
                } else if destination > 0 {
                    destination -= 1
                } else {
                    destination = input.sorted().last!
                    insertIndex = input.firstIndex(of: destination)!
                    break
                }
            }
            
            if insertIndex < input.count {
                insertIndex += 1
            }

            input.insert(three, at: insertIndex)
            input.insert(two, at: insertIndex)
            input.insert(one, at: insertIndex)

            index = input.firstIndex(of: next)!
//            while input.firstIndex(of: next)! != index {
//                input.append(input.removeFirst())
//            }
            
//            printResult(cups: before, pickUp: [one, two, three], destination: destination, result: input, move: i+1, next: next)
        }
        
        var output = [Int]()
        for _ in 0..<input.count {
            output.append(input.remove(at: findIndex(start: input.firstIndex(of: 1)!, increment: 1, valueCount: input.count)))
        }
        output.removeLast()
        return Int(output.map({ String($0) }).joined())!
    }
        
    public func part2(_ input: [Int], turns: Int = 10_000_000) -> Int {
        var cups = Array((1...1_000_000))
        
        for i in 0..<input.count {
            cups[i] = input[i]
        }
        var index = 0
        
        for i in 0..<turns {
//            let before = cups
            let current = cups[index]
            var destinationValue = cups[index] - 1
            
            let next = cups[findIndex(start: index, increment: 4, valueCount: cups.count)]
            let one = cups.remove(at: findIndex(start: cups.firstIndex(of: current)!, increment: 1, valueCount: cups.count))
            let two = cups.remove(at: findIndex(start: cups.firstIndex(of: current)!, increment: 1, valueCount: cups.count))
            let three = cups.remove(at: findIndex(start: cups.firstIndex(of: current)!, increment: 1, valueCount: cups.count))

            var insertIndex = 0
            while true {
                if let index = cups.firstIndex(of: destinationValue) {
                    insertIndex = index
                    break
                } else if destinationValue > 0 {
                    destinationValue -= 1
                } else {
                    destinationValue = cups.sorted().last!
                    insertIndex = cups.firstIndex(of: destinationValue)!
                    break
                }
            }
            
            if insertIndex < cups.count {
                insertIndex += 1
            }

            cups.insert(three, at: insertIndex)
            cups.insert(two, at: insertIndex)
            cups.insert(one, at: insertIndex)

            index = cups.firstIndex(of: next)!
            
//            printResult(cups: before, pickUp: [one, two, three], destination: destination, result: input, move: i+1, next: next)
            if i % 10000 == 0 {
                print(i)
            }
        }
        
        var output = [Int]()
        for _ in 0..<2 {
            output.append(cups.remove(at: findIndex(start: cups.firstIndex(of: 1)!, increment: 1, valueCount: cups.count)))
        }
        
        return output.reduce(1, *)
    }
}

public extension Day23 {
    func printResult(cups: [Int], pickUp: [Int], destination: Int, result: [Int], move: Int, next: Int) {
        print("-- move", move, "--")
        print("cups:", cups.map({ String($0) }).joined(separator: " "))
        print("pick up:", pickUp.map({ String($0) }).joined(separator: ", "))
        print("destination:", destination)
        print("next:", next)
//        print("result:", result.map({ String($0) }).joined(separator: " "))
        print()
    }
    
    func findIndex(start: Int, increment: Int, valueCount: Int) -> Int {
        var index = start + increment
        if index >= valueCount {
            index -= valueCount
        }
        return index
    }
}
