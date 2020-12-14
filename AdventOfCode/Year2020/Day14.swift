import Foundation
import StandardLibraries

public class Day14 {
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
        
        static let update = try! RegularExpression(pattern: "mask = ([01X]+)")
        static let write = try! RegularExpression(pattern: #"mem\[([0-9]+)\] = ([0-9]+)"#)
        public static func parse2(input: String) -> Instruction? {
            if let match = try? write.match(input) {
                return try? .mem(match.integer(at: 0), match.integer(at: 1))
            } else if let match = try? update.match(input) {
                return try? .mask((match.string(at: 0)))
            }
            return nil
        }
    }
    
    public init(iterationsToBuild: [Int] = [4, 8, 6, 9, 5, 7]) {
        cachedIterationSets = Day14.buildCachedIterationSets(input: iterationsToBuild)
    }
    
    public func parse(_ input: [String]) -> [Instruction] {
        return input.compactMap(Instruction.parse)
    }
    
    public func applyMask(value: Int, mask: String) -> Int {
        let input = value.binary(padLength: mask.count)
        var output = ""
        for (i, m) in zip(input, mask) {
            if m == "X" {
                output.append(i)
            } else {
                output.append(m)
            }
        }
        return Int(output, radix: 2) ?? 0
    }
    
    public func part1(_ input: [Instruction]) -> Int {
        var memory = [Int:Int]()
        var mask = ""
        
        for instruction in input {
            switch instruction {
            case let .mask(value): mask = value
            case let .mem(index, value):
                memory[index] = applyMask(value: value, mask: mask)
            }
        }
        
        return memory.values.reduce(0, +)
    }
    
    public func part2(_ input: [Instruction], applyMask: (Int, String) -> [Int]) -> Int {
        var memory = [Int:Int]()
        var mask = ""
        
        for instruction in input {
            switch instruction {
            case let .mask(value):
                mask = value
            case let .mem(index, value):
                applyMask(index, mask)
                    .forEach { memory[$0] = value }
            }
        }
        
        return memory.values.reduce(0, +)
    }
    
    let cachedIterationSets: [Int: [String]]
    let emptyArray = Array<Character>(repeating: "0", count: 36)

    private static func buildCachedIterationSets(input: [Int] = [4, 8, 6, 9, 5, 7]) -> [Int: [String]] {
        var iterationResults = [Int: [String]]()
        for x in input {
            let iterations = Int(pow(Double(2), Double(x)))
            var its = [String]()
            for i in 0..<iterations {
                its.append(i.binary(padLength: x))
            }
            iterationResults[x] = its
        }
        return iterationResults
    }
    
    public func applyMask2(arrayIndex: Int, mask: String) -> [Int] {
        let maskedIndex = convertToMasked(arrayIndex: arrayIndex, mask: mask)
        let xs = indexesOf(input: maskedIndex)
        let base = Int(maskedIndex.replacingOccurrences(of: "X", with: "0"), radix: 2) ?? 0
        var results = [Int]()
        let iterations = cachedIterationSets[xs.count]!
        for binary in iterations {
            var result = emptyArray
            for (b, index) in zip(binary, xs) {
                result[index] = b
            }
            let value = Int(String(result), radix: 2) ?? 0
            results.append(base + value)
        }
        return results
    }
    
    public func applyMask3(arrayIndex: Int, mask: String) -> [Int] {
        let maskedIndex = convertToMasked(arrayIndex: arrayIndex, mask: mask)
        let xs = indexesOf(input: maskedIndex)
        let base = Int(maskedIndex.replacingOccurrences(of: "X", with: "0"), radix: 2)!
        let iterations = cachedIterationSets[xs.count]!
        
        return iterations.map {
            var result = emptyArray
            for (b, index) in zip($0, xs) {
                result[index] = b
            }
            let value = Int(String(result), radix: 2)!
            return base + value
        }
    }

    private func convertToMasked(arrayIndex: Int, mask: String) -> String {
        let input = arrayIndex.binary(padLength: mask.count)
        return zip(input, mask).reduce("") { $0 + String($1.1 == "0" ? $1.0 : $1.1) }
    }
    
    private func indexesOf(input: String, char: Character = "X") -> [Int] {
        return input.enumerated().compactMap { $1 == char ? $0 : nil }
    }
}
