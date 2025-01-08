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
    
    struct CacheKey: Hashable {
        let molecule: String
        let steps: Int
    }
    // https://github.com/fizbin/adventofcode/blob/main/aoc2015/aoc19.2.py
    public func part2(_ input: [String]) throws -> Int {
        let (options, smolecule) = parse2(input)
        let rulesAr = options.filter { $0.0.hasSuffix("Ar") }
        let rulesNormal = options.filter { !$0.0.hasSuffix("Ar") }
        var regexCache = [String: RegularExpression]()
        for option in options {
            regexCache[option.0] = try? RegularExpression(pattern: RegularExpression.Pattern(option.0))
        }
        
        let regexRecursive = try RegularExpression("(?:Rn|Y)((?:(?!Ar|Y|Rn)[A-Z][a-z]?){2,})(?=Y|Ar)")
        let regexNarrowing = try RegularExpression("(?:^|Rn|Y)((?:(?!Ar|Y|Rn)[A-Z][a-z]?)+)|(?=Rn[A-Z][a-z]?Ar|Rn[A-Z][a-z]?Y[A-Z][a-z]?Ar)")
        var seen = [String: (Int, String)]()
        var i = 0
        
        func reduceMolecule(_ molecule: String) throws -> (Int, String) {
            var visited = [String: Int]()
            let queue = PriorityQueue<CacheKey>()
            queue.enqueue(CacheKey(molecule: molecule, steps: 0), priority: 0)
            
            while let queuedItem = queue.dequeue() {
                i += 1
                if i % 10000 == 0 {
                    print(i, seen.count, visited.count, queuedItem.steps)
                }
                var molecule = queuedItem.molecule
                var steps = queuedItem.steps
                
                if molecule.count == 1 || (molecule.count == 2 && molecule != molecule.uppercased()) {
                    return (steps, molecule)
                }
                
                let matches = regexRecursive.matches(in: queuedItem.molecule)
                if !matches.isEmpty {
                    for match in matches.reversed() {
                        var add_one = 0
                        var rep_one = ""
                        let valueToReduce = try match.string(at: 0)
                        if seen[valueToReduce] != nil {
                            (add_one, rep_one) = seen[valueToReduce]!
                        } else {
                            (add_one, rep_one) = try reduceMolecule(try match.string(at: 0))
                            seen[valueToReduce] = (add_one, rep_one)
                        }
                        molecule = molecule.replacingCharacters(in: match.range, with: rep_one)
                        steps += add_one
                        queue.enqueue(CacheKey(molecule: molecule, steps: steps), priority: steps + molecule.count)
                    }
                    continue
                }
                
                for (from, to) in rulesAr {
                    if let match = regexCache[from]!.matches(in: molecule).first {
                        let reduction = molecule.replacingCharacters(in: match.range, with: to)
                        if visited[reduction, default: steps + 10] > steps + 1 {
                            visited[reduction] = steps + 1
                            queue.enqueue(CacheKey(molecule: reduction, steps: steps + 1), priority: steps + 1 + reduction.count)
                            break
                        }

                    }
                }
                
                let matches2 = regexNarrowing.matches(in: molecule).first
                for (from, to) in rulesNormal {
                    for match in regexCache[from]!.matches(in: molecule) {
                        if let matches2 = matches2, !(matches2.range.lowerBound <= match.range.lowerBound && matches2.range.upperBound >= match.range.upperBound) {
                            continue
                        }
                        
                        let reduction = molecule.replacingCharacters(in: match.range, with: to)
                        if visited[reduction, default: steps + 10] > steps + 1 {
                            visited[reduction] = steps + 1
                            queue.enqueue(CacheKey(molecule: reduction, steps: steps + 1), priority: steps + 1 + reduction.count)
                        }
                    }
                }
            }
//            fatalError("Found a molecule that couldn't be reduced: \(molecule). This should never happen.")
            if let shortest = visited.map({ $0.0 }).sorted(by: { $0.count < $1.count }).first {
                return (visited[shortest, default: 0], shortest)
            }
            return (0, molecule)
        }
        
        let result = try reduceMolecule(smolecule)
        print(result.0, result.1.count, result.1)
        return result.0
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
