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
    
    fileprivate static var attemptedNodes = Set<Node>()
    
    fileprivate class Node: Hashable {
        static func == (lhs: Day19.Node, rhs: Day19.Node) -> Bool {
            lhs.key == rhs.key
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(key)
        }
        
        let key: String
        let depth: Int
        var options: [Node]
        
        init(key: String, depth: Int) {
            self.key = key
            self.depth = depth
            self.options = []
        }
        
        func calculateOptions(sortedKeys: [String], replacementOptions: Options) -> Bool {
            for sortedKey in sortedKeys {
                let ranges = key.ranges(of: sortedKey)
                guard !ranges.isEmpty else { continue }
                
                for range in ranges {
                    for value in replacementOptions[sortedKey]! {
                        var input = key
                        input.replaceSubrange(range, with: value)
                        if input == "e" {
                            return true
                        } else {
                            let node = Node(key: input, depth: depth+1)
                            if !Day19.attemptedNodes.contains(node) {
                                options.append(node)
                            }
                        }
                    }
                }
            }
            
            return false
        }
        
        func solve(sortedKeys: [String], replacementOptions: Options) -> Int {
            Day19.attemptedNodes.insert(self)

            if calculateOptions(sortedKeys: sortedKeys, replacementOptions: replacementOptions) {
                return depth + 1
            }
            
            for option in options.sorted(by: { $0.key < $1.key }) {
                let result = option.solve(sortedKeys: sortedKeys, replacementOptions: replacementOptions)
                if result > -1 {
                    return result
                }
            }
            
            return -1
        }
    }
    
    public func part2(_ input: [String]) -> Int {
        Day19.attemptedNodes = []
        let (options, molecule) = parse2(input)
        let sortedKeys: [(String, String)] = options.sorted(by: { $0.0.count - $0.1.count > $1.0.count - $1.1.count })
        var variant = molecule
        var steps = 0
        
        while variant != "e" {
            var reduced = false
            for (from, to) in sortedKeys {
                var found = false
                while variant.contains(from) {
                    let range = variant.firstRange(of: from)!
                    variant.replaceSubrange(range, with: to)
                    found = true
                }
                if found {
                    reduced = true
                    steps += 1
                    print(steps, from, variant)
                }
            }
            if !reduced { break }
        }
//        for key in sortedKeys {
//            let filteredKeys = sortedKeys.filter({ $0 != key })
//            guard molecule.contains(key.0) { continue }
//            if !filteredKeys.compactMap({ $0.contains(key) ? $0 : nil }).isEmpty { continue }
//            sortedKeys.removeAll(where: { $0 == key })
//            print(key)
//        }
//        print("Keys count", sortedKeys.count)
//        let node = Node(key: molecule, depth: 0)
//        return node.solve(sortedKeys: sortedKeys, replacementOptions: options)
        return steps
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
