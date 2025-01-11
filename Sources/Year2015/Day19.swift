import Foundation
import StandardLibraries

public class Day19 {
    public init() {}
    
    public typealias Options = [String: [String]]
    
    // 10x faster
    public func part1b(_ input: [String]) -> Int {
        let (options, molecule) = parse(input)
        var variants = Set<String>()
        
        for i in (0..<molecule.count) {
            let key1 = String(molecule[i])
            if let keys = options[key1] {
                for key in keys {
                    var newValue = molecule
                    newValue.replaceSubrange((newValue.index(newValue.startIndex, offsetBy: i)..<newValue.index(newValue.startIndex, offsetBy: i+1)), with: key)
                    variants.insert(newValue)
                }
            }
            
            if i == 0 { continue }
            
            let key2 = String(molecule[i-1] + molecule[i])
            if let keys = options[key2] {
                for key in keys {
                    var newValue = molecule
                    newValue.replaceSubrange((newValue.index(newValue.startIndex, offsetBy: i-1)..<newValue.index(newValue.startIndex, offsetBy: i+1)), with: key)
                    variants.insert(newValue)
                }
            }
        }
        
        return variants.count
    }
    
    public func part1(_ input: [String]) -> Int {
        let (items, molecule) = parse(input)
        var options = Set<String>()
        
        for key in items.keys {
            if key.count == 2 {
                for value in items[key]! {
                    for option in countDouble(key: key, value: value, input: molecule) {
                        options.insert(option)
                    }
                }
            } else {
                for value in items[key]! {
                    for option in countSingle(key: key, value: value, input: molecule) {
                        options.insert(option)
                    }
                }
            }
        }
        
        return options.count
    }
    
    public func countDouble(key: String, value: String, input: String) -> Set<String> {
        var variants = Set<String>()
        for i in (1..<input.count) {
            if key == input[i-1] + input[i] {
                let newValue = input.replacingOccurrences(of: key, with: value, options: [], range: (input.index(input.startIndex, offsetBy: i-1)..<input.index(input.startIndex, offsetBy: i+1)))
                variants.insert(newValue)
            }
        }
        return variants
    }
    
    public func countSingle(key: String, value: String, input: String) -> Set<String> {
        var variants = Set<String>()
        for i in (0..<input.count) {
            if key == input[i] {
                let newValue = input.replacingOccurrences(of: key, with: value, options: [], range: (input.index(input.startIndex, offsetBy: i)..<input.index(input.startIndex, offsetBy: i+1)))
                variants.insert(newValue)
            }
        }
        return variants
    }
    
    public func part2b(_ input: [String]) throws -> Int {
        var (options, molecule) = parse2(input)
        molecule = String(molecule.reversed())
        options = options.map({ (String($0.0.reversed()), String($0.1.reversed())) })
        let regex = try RegularExpression(pattern: RegularExpression.Pattern("(" + options.map({ $0.0 }).joined(separator: "|") + ")"))
        
        var count = 0
        while molecule != "e" {
            if let match = regex.matches(in: molecule).first {
                let range = match.range
                let from = try match.string(at: 0)
                if let value = options.first(where: { $0.0 == from })?.1 {
                    molecule = molecule.replacingCharacters(in: range, with: value)
                    count += 1
                }
            } else {
                break
            }
        }
        
        return count
    }

    public func parse(_ input: [String]) -> (Options, String) {
        var input = input
        var items = Options()
        
        var line = input.removeFirst()
        while !line.isEmpty {
            let comp = line.components(separatedBy: " => ")
            var options = items[comp[0], default: []]
            options.append(comp[1])
            items[comp[0]] = options
            line = input.removeFirst()
        }
        
        return (items, input.first!)
    }
    
    public func parse2(_ input: [String]) -> ([(String, String)], String) {
        var input = input
        var items = [(String, String)]()
        
        var line = input.removeFirst()
        while !line.isEmpty {
            let comp = line.components(separatedBy: " => ")
            items.append((comp[1], comp[0]))
            line = input.removeFirst()
        }
        
        return (items, input.first!)
    }
}
