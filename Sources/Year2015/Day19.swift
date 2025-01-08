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
                
                for range in ranges.reversed() {
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
    
//    let regexRnar = try! RegularExpression(pattern: "([A-Z][a-z]?Rn([^Rr]+)Ar)")
//    let regexBlocker = try! RegularExpression(pattern: "([A-Z][a-z]?[A-Z][a-z]?)Rn[^Rr]+Ar")
//    let regexOneElement = try! RegularExpression(pattern: "[A-Z][a-z]?")
//    let regexTwoElements = try! RegularExpression(pattern: "^[A-Z][a-z]?[A-Z][a-z]?$")
    
    public func part2c(_ input: [String]) -> Int {
        let (options, molecule) = parse2(input)
        let re = "(" + options.map({ $0.0 }).joined(separator: "|") + ")"
        let fxx = "\(re)Rn\(re)Y\(re)Ar"
        let fx = "\(re)Rn\(re)Ar"
        let xx = "\(re)\(re)"
        let regex = try! RegularExpression(pattern: RegularExpression.Pattern([fxx, fx, xx].joined(separator: "|")))
        var m = molecule
        var steps = 0
        var matches = regex.matches(in: m)
        while matches.count > 0 {
            for match in matches { // do backwards to protect the indexes
                m = m.replacingCharacters(in: match.range, with: "e")
                steps += 1
                break
            }
            matches = regex.matches(in: m)
        }
        print(steps, m.count, m)
        return steps
    }
    
    struct Step: Hashable {
        let molecule: String
        let steps: Int
    }
    
    /*
     Rn => (
     Ar => )
     Y => ,
     x => ()
     x => (,)
     x => (,,)
     x => (,,,)
     */
    
    let regexRnAr = try! RegularExpression(pattern: "([A-Z][a-z]?Rn([^Rr]+)Ar)")
    let regexBlocker = try! RegularExpression(pattern: "([A-Z][a-z]?[A-Z][a-z]?)Rn[^Rr]+Ar")
    let regexOneElement = try! RegularExpression(pattern: "[A-Z][a-z]?")
    let regexTwoElements = try! RegularExpression(pattern: "^[A-Z][a-z]?[A-Z][a-z]?$")
    
    public func part2d(_ input: [String]) throws -> Int {
        let (options, m) = parse2(input)
//        let optionsRnAr = options.filter { regexRnar.matches($0.0) }.sorted(by: >)
//        let pairDown = options.filter { regexTwoElements.matches($0.0) && $0.0.contains($0.1) }
        var molecule = m
        var steps = 0
        
        while molecule != "e" {
            var foundRnAr = false
            for match in regexRnAr.matches(in: molecule).reversed() {
                let from = try match.string(at: 0)
                if let (_, to) = options.first(where: { $0.0 == from }) {
                    foundRnAr = true
                    molecule = molecule.replacingCharacters(in: match.range, with: to)
                    steps += 1
                }
            }
            if foundRnAr { continue }
            
            var foundBlocker = false
            for match in regexBlocker.matches(in: molecule).reversed() {
                let from = try match.string(at: 0)
                if let (_, to) = options.first(where: { $0.0 == from }) {
                    foundBlocker = true
                    molecule = molecule.replacingCharacters(in: match.range, with: to)
                    steps += 1
                }
            }
            if foundBlocker { continue }
            
            var foundTwoElements = false
            for match in regexTwoElements.matches(in: molecule).reversed() {
                let from = try match.string(at: 0)
                if let (_, to) = options.first(where: { $0.0 == from }) {
                    foundTwoElements = true
                    molecule = molecule.replacingCharacters(in: match.range, with: to)
                    steps += 1
                }
            }
            if foundTwoElements { continue }
            
            var foundOption = false
            for (from, to) in options.sorted(by: { $0.0.count > $1.0.count }) where to != "e" {
                for match in molecule.ranges(of: from).reversed() {
                    foundOption = true
                    molecule = molecule.replacingCharacters(in: match, with: to)
                    steps += 1
                }
            }
            if foundOption { continue }
            
            if molecule.count == 2 {
                for (from, to) in options.sorted(by: { $0.0.count > $1.0.count }) where to == "e" {
                    for match in molecule.ranges(of: from).reversed() {
                        molecule = molecule.replacingCharacters(in: match, with: to)
                        steps += 1
                    }
                }
            }
            
            if !foundRnAr && !foundBlocker && !foundTwoElements && !foundOption {
                break
            }
        }
        
        return steps + molecule.count - 1
    }
    
    public func part2b(_ input: [String]) -> Int {
        let (options, molecule) = parse2(input)
        let (repl_RnAr, repl_doubles, repl_e) = splitReplacements(options)
        var answers = [Int]()
        var steps = 0
        var clean = false
        var mol_0 = molecule
        
        while !clean {
            if regexRnAr.matches(in: mol_0).isEmpty {
                clean = true
                continue
            }
            
            // reduce all the inner parts of each Rn..Ar pair
            let (mol_1, steps1) = replaceInners(mol_0, steps, repl_doubles, repl_RnAr)
            steps = steps1
            
            // perform direct xRn..Ar replacements
            var (mol_2, steps2) = applyRnAr(mol_1, steps, repl_RnAr)
            steps = steps2
            
            if mol_1 == mol_2 {
                // if no changes this cycle
                // but still have Rn..Ar sets
                // then we have one or more special blockers
                (mol_2, steps2) = clearBlockers(mol_0, steps, repl_doubles)
                steps = steps2
                if mol_2 == mol_0 {
                    (mol_2, steps2) = clearBlockers(mol_0, steps, repl_e)
                    steps = steps2
//                    fatalError("Clearning blockers failed")
                    break
                }
            }
            mol_0 = mol_2
        }
        
        // now that all Rn..Ar are removed
        // all replacements from now on remove exactly 1 element
        // so we can just count all the remaining elements and math the answer
        answers.append(steps + countElements(mol_0) - 1) // -1 because we start with 1 "element": the electron
        return answers.min()!
    }
    
    struct CacheKey: Hashable {
        let molecule: String
        let steps: Int
    }
    
    func countElements(_ mol_0: String) -> Int {
//        regexOneElement.matches(in: mol_0).count
        mol_0.count
    }
    
    func clearBlockers(_ molecule: String, _ steps: Int, _ repl_doubles: [(String, String)]) -> (String, Int) {
        var blockers = [(String, Range<String.Index>)]()
        var steps = steps
        var molecule = molecule
        
        // for each Rn..Ar, grab the 2 preceeding elements, store their positions in `blockers`
        regexBlocker.matches(in: molecule).forEach { match in
            if let value = try? match.string(at: 0) {
                blockers.append((value, match.range))
            }
        }
        
        // for each of the found spans
        // perform the only possible replacement
        for (blocker0, range) in blockers.reversed() { // reversed because we start replacing from the end to avoid corrupting indexes
            if let (_, to) = repl_doubles.first(where: { $0.0 == blocker0 }) {
                molecule = molecule.replacingCharacters(in: range, with: to)
                steps += 1
            }
        }
        
        return (molecule, steps)
    }
    
    // perform direct xRn..Ar replacements
    func applyRnAr(_ molecule: String, _ steps: Int, _ repl_RnAr: [(String, String)]) -> (String, Int) {
        let check = try! RegularExpression(pattern: RegularExpression.Pattern(repl_RnAr.map({ ".*\($0.0).*" }).joined(separator: "|")))
        var mol_2 = molecule
        var steps_2 = steps
        while !check.matches(in: mol_2).isEmpty {
            for (from, to) in repl_RnAr {
                for range in mol_2.ranges(of: from).reversed() {
                    mol_2 = mol_2.replacingCharacters(in: range, with: to)
                    steps_2 += 1
                }
            }
        }
        return (mol_2, steps_2)
    }
    
    func replaceInners(_ molecule: String, _ steps: Int, _ repl_doubles: [(String, String)], _ repl_RnAr: [(String, String)]) -> (String, Int) {
        var mol_1 = molecule
        var steps = steps
        var inners = [(String, String, Range<String.Index>)]()
        
        // grab a Set of the inner elements between Rn and Ar in the replacement options
        // we use this in comparisons later on
        let innersRnArMatches = regexRnAr.matches(in: mol_1)
        let innersRnAr = innersRnArMatches.compactMap { try? $0.string(at: 1) }
        
        // Find a list of the inner spans between Rn and Ar in the molecule
        innersRnArMatches.forEach {
            if let start = try? $0.string(at: 0), let end = try? $0.string(at: 1) {
                inners.append((start, end, $0.range))
            }
        }
        
        // For each inner span we found above
        // Perform elemental replacements on the inner span
        // until it matches one of the target RnAr replacement combinations (inners_RnAr)
        // loop reversed.  We start replacing from the end first to avoid corrupting indexes
        for (start, _, range) in inners.reversed() {
            let inner0: String = start //mol_1[start..<end]
            let steps0 = steps
            var minSteps = Int.max
            var clean: Set<CacheKey> = [CacheKey(molecule: inner0, steps: steps0)]
            var q: [(String, Int)] = [(inner0, steps0)]
            var processed = [String: Int]()
            
            // perform elemental replacements on this span
            // until it matches one of the target RnAr replacement combinations (inners_RnAr)
            while !q.isEmpty {
                let (inner1, steps1) = q.removeLast()
                if steps1 > minSteps { continue }
                if innersRnAr.contains(inner1) {
                    clean.insert(CacheKey(molecule: inner1, steps: steps1))
                    minSteps = min(minSteps, steps1)
//                    continue
                }
                
                for (from, to) in repl_doubles {
                    if inner1.contains(from) {
                        for range in inner1.ranges(of: from).reversed() {
                            let inner2 = inner1.replacingCharacters(in: range, with: to)
                            let steps2 = steps1 + 1
                            if steps2 >= processed[inner2, default: Int.max] {
                                continue
                            }
                            q.append((inner2, steps2))
                            processed[inner2] = steps2
                        }
                    }
                }
            }
            
            // If there's only one final version of the inner span (Ideally this should be true)
            // Select the fastest way to get to it
            // And replace the inner span in the actual molecule
            if clean.count == 1 {
                steps = min(clean.map { $0.steps }.min() ?? Int.max, steps)
                let inner3 = clean.first!.molecule
                mol_1 = mol_1.replacingCharacters(in: range, with: inner3)
            } else {
                fatalError("oops")
            }
        }
        
        return (mol_1, steps)
    }
    
    func splitReplacements(_ options: [(String, String)]) -> ([(String, String)], [(String, String)], [(String, String)]) {
        var repl_RnAr = [(String, String)]()
        var repl_doubles = [(String, String)]()
        var repl_e = [(String, String)]()
        
        for option in options {
            if option.0.contains("Rn") {
                repl_RnAr.append(option)
            } else if option.1.contains("e") {
                repl_e.append(option)
            } else {
                repl_doubles.append(option)
            }
        }
        
        return (repl_RnAr, repl_doubles, repl_e)
    }
    
    public func part2(_ input: [String]) -> Int {
        Day19.attemptedNodes = []
        let (options, molecule) = parse2(input)
        let sortedKeys: [(String, String)] = options.sorted(by: { $0.0.count - $0.1.count > $1.0.count - $1.1.count })
        let queue = PriorityQueue<Step>()
        queue.enqueue(Step(molecule: molecule, steps: 0), priority: 0)
        var smallest = Int.max
        var i = 0
//        var seen = Set<String>()
        
        while let step = queue.dequeue() {
            i += 1
            if i % 100000 == 0 {
                print(i, step.steps, step.molecule.count, queue.queuedItems.count, smallest)
            }
            guard step.steps < smallest else { continue }
            for (from, to) in sortedKeys {
                let variant = step.molecule.replacingOccurrences(of: from, with: to)
                if step.molecule.count == variant.count {
                    continue
                }
                let instances = (step.molecule.count - variant.count) / from.count
                if variant == "e" {
                    smallest = min(smallest, step.steps + instances)
                    continue
                }
//                if !seen.contains(variant) {
//                    seen.insert(variant)
                    queue.enqueue(Step(molecule: variant, steps: step.steps + instances), priority: -(step.steps + instances))
//                }
            }
        }
        return smallest
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
