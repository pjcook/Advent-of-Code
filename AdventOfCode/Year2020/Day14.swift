import Foundation
import StandardLibraries

public struct Day14 {
    public enum Instruction {
        case mask(String)
        case mem(Int, Int)
        
        public static func parse(input: String) -> Instruction? {
            if input.hasPrefix("mem") {
                let lower = input.index(input.firstIndex(of: "[")!, offsetBy: 1)
                let upper = input.index(input.firstIndex(of: "]")!, offsetBy: -1)
                let eq = input.index(input.firstIndex(of: "=")!, offsetBy: 2)
                let index = Int(input[(lower...upper)])!
                let value = Int(input[(eq...)])!
                return .mem(index, value)
                
            } else if input.hasPrefix("mask") {
                let value = String(input.substring(fromIndex: 7))
                return .mask(value)
                
            } else {
                return nil
            }
        }
    }
    
    public init() {}
    
    public func parse(_ input: [String]) -> [Instruction] {
        return input.compactMap(Instruction.parse)
    }
    
    public func applyMask(value: Int, mask: String) -> Int {
        let binary = String(value, radix: 2)
        let input = String(repeating: "0", count: mask.count - binary.count) + binary
        var output = ""
        zip(input, mask).forEach { (i,m) in
            if m == "X" {
                output.append(i)
            } else {
                output.append(m)
            }
        }
        return Int(output, radix: 2) ?? 0
    }
    
    public func part1(_ input: [String]) -> Int {
        let instructions = parse(input)
        var memory = [Int:Int]()
        var mask = String(repeating: "X", count: 36)
        
        for instruction in instructions {
            switch instruction {
            case let .mask(value):
                mask = value
                
            case let .mem(index, value):
                memory[index] = applyMask(value: value, mask: mask)
            }
        }
        
        return memory.values.reduce(0, +)
    }
    
    public func part2(_ input: [String]) -> Int {
        let instructions = parse(input)
        var memory = [Int:Int]()
        var mask = String(repeating: "X", count: 36)
        
        for instruction in instructions {
            switch instruction {
            case let .mask(value):
                mask = value
                
            case let .mem(index, value):
                applyMask2(value: index, mask: mask)
                    .forEach { memory[$0] = value }
                
            }
        }
        
        return memory.values.reduce(0, +)
    }
    
    public func applyMask2(value: Int, mask: String) -> [Int] {
        let binary = String(value, radix: 2)
        let input = String(repeating: "0", count: mask.count - binary.count) + binary
        var output = ""
        zip(input, mask).forEach { (i,m) in
            if m == "0" {
                output.append(i)
            } else {
                output.append(m)
            }
        }
        var results = [Int]()
        var xs = [Int]()
        for (index, x) in output.enumerated() {
            if x == "X" {
                xs.append(index)
            }
        }
        
        let base = Int(output.replacingOccurrences(of: "X", with: "0"), radix: 2) ?? 0
        let iterations = Int("1" + String(repeating: "0", count: xs.count), radix: 2) ?? 0
        
        for i in 0..<iterations {
            let binary = String(i, radix: 2)
            let binary2 = String(repeating: "0", count: xs.count - binary.count) + binary
            var result = Array(repeating: "0", count: mask.count)
            zip(binary2, xs).forEach { (b, index) in
                result[index] = String(b)
            }
            let value = Int(result.joined(), radix: 2) ?? 0
            results.append(base + value)
        }
        
        return results
    }
}
