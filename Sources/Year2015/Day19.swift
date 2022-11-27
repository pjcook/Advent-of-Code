import Foundation
import StandardLibraries

public class Day19 {
    public init() {}
    
    public typealias Options = [String:[String]]
    
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
    
    public func part2(_ input: [String]) -> Int {
        let (items, molecule) = parse(input)
        var options = [String:String]()
        for item in items {
            for value in item.value {
                options[value] = item.key
            }
        }
        return destruct2(molecule, options: options, depth: 1, minDepth: Int.max)
    }
    
    public func destruct2(_ molecule: String, options: [String:String], depth: Int, minDepth: Int) -> Int {
        guard depth < 20 else { return minDepth }
        guard !attempts.contains(molecule), depth < minDepth else { return minDepth }
        guard molecule != "e" else { return min(depth, minDepth) }
        attempts.insert(molecule)
        minLength = min(minLength, molecule.count)
        print(minLength, molecule.count, depth, minDepth, attempts.count, molecule)
        var newMinDepth = minDepth
        for key in options.keys.sorted(by: { $0.count > $1.count }) {
            var string = molecule
            let count = countNonOverlapping(key, content: string)
            if count > 0 {
                string = string.replacingOccurrences(of: key, with: options[key]!)
                newMinDepth = min(newMinDepth, destruct2(string, options: options, depth: depth + count, minDepth: minDepth))
            }
        }
     return newMinDepth
    }
    
    public func countNonOverlapping(_ word: String, content: String) -> Int {
        var count = 0
        var i = word.count
        while i <= content.count {
            if content[i-word.count..<i] == word {
                count += 1
                i += word.count
            } else {
                i += 1
            }
        }
        return count
    }
    
    var attempts = Set<String>()
    var minLength = Int.max
    public func destruct(_ molecule: String, options: [String:String], depth: Int, minDepth: Int) -> Int {
        guard !attempts.contains(molecule), depth < minDepth else { return minDepth }
        attempts.insert(molecule)
        minLength = min(minLength, molecule.count)
        print(minLength, molecule.count, depth, minDepth, attempts.count, molecule)
        var newMinDepth = minDepth
        for key in options.keys.sorted().reversed() {
            if key.count > molecule.count {
                continue
            } else if key == molecule {
                let newValue = options[key]!
                if newValue == "e" {
                    newMinDepth = min(minDepth, depth)
                } else {
                    newMinDepth = destruct(newValue, options: options, depth: depth + 1, minDepth: newMinDepth)
                }
                continue
            }
            for i in (0..<molecule.count - key.count) {
                let start = i
                let end = start + key.count
                if molecule[start..<end] == key {
                    let range = (molecule.index(molecule.startIndex, offsetBy: start)..<molecule.index(molecule.startIndex, offsetBy: end+1))
                    let newValue = molecule.replacingOccurrences(of: key, with: options[key]!, options: [], range: range)
                    if newValue == "e" {
                        newMinDepth = min(minDepth, depth)
                    } else {
                        newMinDepth = destruct(newValue, options: options, depth: depth + 1, minDepth: newMinDepth)
                    }
                }
            }
        }
        return newMinDepth
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
}
