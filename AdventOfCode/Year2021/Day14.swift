import Foundation
import StandardLibraries

public struct Day14 {
    public init() {}
    
    public func part1(_ input: [String], steps: Int) -> Int {
        var (template, pairs) = parse(input)
        for step in (0..<steps) {
            var i = 1
            while i < template.count {
                let key = template[i-1] + template[i]
                if let value = pairs[key] {
                    template.insert(value, at: i)
                    i += 1
                }
                
                i += 1
            }
        }
        var chars = [String:Int]()
        for char in template {
            chars[char, default: 0] += 1
        }
        let sorted = chars.values.sorted()
        return sorted.last! - sorted.first!
    }
    
    public func part2(_ input: [String], steps: Int) -> Int {
        let (template, pairs) = parse(input)
        var found = [String:Int]()
        
        var i = 1
        while i < template.count {
            let key = template[i-1] + template[i]
            found[key, default: 0] += 1
            i += 1
        }
        
        for _ in (0..<steps) {
            var newFound = [String:Int]()
            for item in found {
                let c = pairs[item.key]!
                let key1 = String(item.key[0]) + c
                let key2 = c + String(item.key[1])
                newFound[key1, default: 0] += item.value
                newFound[key2, default: 0] += item.value
            }
            found = newFound
        }
        
        var chars = [String:Int]()
        for item in found {
            chars[String(item.key[0]), default: 0] += item.value
            chars[String(item.key[1]), default: 0] += item.value
        }
        let sorted = chars.values.sorted()
        return Int((Double(sorted.last! - sorted.first!) / 2) + 0.5)
    }
    
    public func parse(_ input: [String]) -> ([String], [String:String]) {
        let template = input[0].map { String($0) }
        var pairs = [String:String]()
        for i in (2..<input.count) {
            let split = input[i].components(separatedBy: " -> ")
            pairs[split[0]] = split[1]
        }
        return (template, pairs)
    }
}
