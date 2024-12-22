import Foundation
import InputReader
import StandardLibraries

public class Day21 {
    public init() {
        let numberKeys = """
789
456
123
X0A
"""
        numPadSteps = Self.generateSteps(str: numberKeys)
        
        let dPadKeys = """
X^A
<v>
"""
        dPadSteps = Self.generateSteps(str: dPadKeys)
    }
    
    struct CacheKey: Hashable {
        let value: String
        let depth: Int
    }
    
    private var cache = [CacheKey: [String]]()
    private let numPadSteps: [String: [String]]
    private let dPadSteps: [String: [String]]
    
    public func part1(_ input: [String], chainLength: Int) -> Int {
        var result = 0
        
        for line in input {
            let instructions = convertInputToInstructions(line, chainLength: chainLength)
            let value = Int(line.replacingOccurrences(of: "A", with: ""))!
            result += instructions.count * value
        }
        
        return result
    }
    
    struct State: Hashable {
        let current: Character
        let next: Character
        let depth: Int
    }
    
    public func part2b(_ input: [String]) -> Int {
        var result = 0
        var cache = [State: Int]()
        
        for code in input {
            var value = 0
            var current: Character = "A"
            for next in code {
                value += numberOfKeyPresses(map: numPadSteps, state: State(current: current, next: next, depth: 26), cache: &cache)
                current = next
            }
            let complexity = value * Int(code.replacingOccurrences(of: "A", with: ""))!
            result += complexity
        }
        
        return result
    }
    
    public func part2(_ input: [String], chainLength: Int) -> Int {
        var result: Int = 0
        var memory = [String: Int]()
        
        for line in input {
            let m = relayInput(line, memory: &memory, chainLength: chainLength)
            let value = Int(line.replacingOccurrences(of: "A", with: ""))!
            print("Result", line, m, value)
            result += m * value
        }
        
        return Int(result)
    }
        
    func relayInput(_ input: String, memory: inout [String: Int], chainLength: Int) -> Int {
        print("Checking", input)
        var current = Character("A")
        var step1min: Int = 0
        var i = 0
        while i < input.count {
            let next = Character(input[i])
            let options = numPadSteps["\(current)\(next)"]! // numberPadRoute(from: current, to: next)
            let m = relayKeypress(k1: options, depth: chainLength, memory: &memory)
            step1min += m
            print(current, next, m, options)
            current = next
            i += 1
        }

        return step1min        
    }
    
    func relayKeypress(k1: [String], depth: Int, memory: inout [String: Int]) -> Int {
//        print("Depth", depth, k1.count, k1[0].count, memory.count)
        if depth == 0 {
            return k1.map({ $0.count }).min()!
        }
        var step1min = Int.max
        for k2 in k1 {
            var step1 = 0
            var current = Character("A")
            var i = 0
            while i < k2.count {
                let next = Character(k2[i])
                let cacheKey = "\(current) \(next) \(depth)"
                var m = memory[cacheKey]
                if m == nil {
                    let options = dPadSteps["\(current)\(next)"]! // directionalPadRoute(from: current, to: next)
                    m = relayKeypress(k1: options, depth: depth - 1, memory: &memory)
                    memory[cacheKey] = m
                }
                step1 += m!
                current = next
                i += 1
            }
            step1min = min(step1, step1min)
        }
        return step1min
    }
}

extension Day21 {
    func convertInputToInstructions(_ input: String, chainLength: Int) -> String {
        var instructions = ["", ""]
        var current = Character("A")
        
        var i = 0
        while i < input.count {
            let next = Character(input[i])
            let options = numberPadRoute(from: current, to: next)
            
            let option1 = options[0]
            let option2 = options.count == 1 ? option1 : options[1]
            
            instructions[0] = instructions[0] + option1
            instructions[1] = instructions[1] + option2
            
            current = next
            i += 1
        }
        
        instructions = calculateChainedRobotInstructions(instructions: instructions, depth: chainLength)
        
        return instructions.sorted(by: { $0.count < $1.count }).first!
    }
        
    func calculateChainedRobotInstructions(instructions: [String], depth: Int) -> [String] {
//        print(depth, cache.count, instructions.count, instructions[0].count)
        let instructionSet = Set(instructions)
        var instructions2 = Set<String>()
        for instruction in instructionSet {
            if let result = cache[CacheKey(value: instruction, depth: depth)] {
                return result
            }
            var current = Character("A")
            var i = 0
            var a = ""
            var b = ""
            
            while i < instruction.count {
                let next = Character(instruction[i])
                let options = directionalPadRoute(from: current, to: next)
                
                let option1 = options[0]
                let option2 = options.count == 1 ? option1 : options[1]
                a = a + option1
                b = b + option2
                current = next
                i += 1
            }
            
            if a.count == b.count && a != b {
                instructions2.insert(a)
                instructions2.insert(b)
            } else if a.count < b.count {
                instructions2.insert(a)
            } else {
                instructions2.insert(b)
            }
        }
        
        if depth == 1 {
            return Array(instructions2)
        }
        let result = calculateChainedRobotInstructions(instructions: Array(instructions2), depth: depth - 1)
        let minLength = result.sorted(by: { $0.count < $1.count })[0].count
        let filteredResults = result.filter { $0.count == minLength }
        for instruction in instructions {
            cache[CacheKey(value: instruction, depth: depth)] = filteredResults
        }
        return filteredResults
    }
    
    func numberOfKeyPresses(map: [String: [String]], state: State, cache: inout [State: Int]) -> Int {
        if let result = cache[state] {
            return result
        }
        
        if state.depth == 0 {
             return 1
        }
        
        var best = Int.max
        for steps in map[String(state.current) + String(state.next)]! {
            var value = 0
            var current: Character = "A"
            for next in steps {
                value += numberOfKeyPresses(
                    map: dPadSteps,
                    state: State(current: current, next: next, depth: state.depth - 1), cache: &cache)
                current = next
            }
            if value < best {
                best = value
            }
        }
        cache[state] = best
        return best
    }
    
    /*
     +---+---+---+
     | 7 | 8 | 9 |
     +---+---+---+
     | 4 | 5 | 6 |
     +---+---+---+
     | 1 | 2 | 3 |
     +---+---+---+
         | 0 | A |
         +---+---+
     */
    func numberPadRoute(from: Character, to: Character) -> [String] {
        guard from != to else { return ["A"] }
        
        switch (from, to) {
        case ("A", "0"): return ["<A"]
        case ("A", "1"): return ["^<<A"]
        case ("A", "2"): return ["^<A", "<^A"]
        case ("A", "3"): return ["^A"]
        case ("A", "4"): return ["^^<<A"]
        case ("A", "5"): return ["^^<A", "<^^A"]
        case ("A", "6"): return ["^^A"]
        case ("A", "7"): return ["^^^<<A"]
        case ("A", "8"): return ["^^^<A", "<^^^A"]
        case ("A", "9"): return ["^^^A"]

        case ("0", "A"): return [">A"]
        case ("0", "1"): return ["^<A"]
        case ("0", "2"): return ["^A"]
        case ("0", "3"): return ["^>A", ">^A"]
        case ("0", "4"): return ["^^<A"]
        case ("0", "5"): return ["^^A"]
        case ("0", "6"): return ["^^>A", ">^^A"]
        case ("0", "7"): return ["^^^<A"]
        case ("0", "8"): return ["^^^A"]
        case ("0", "9"): return ["^^^>A", ">^^^A"]
            
        case ("1", "0"): return [">vA"]
        case ("1", "A"): return [">>vA"]
        case ("1", "2"): return [">A"]
        case ("1", "3"): return [">>A"]
        case ("1", "4"): return ["^A"]
        case ("1", "5"): return ["^>A", ">^A"]
        case ("1", "6"): return ["^>>A", ">>^A"]
        case ("1", "7"): return ["^^A"]
        case ("1", "8"): return ["^^>A", ">^^A"]
        case ("1", "9"): return ["^^>>A", ">>^^A"]
            
        case ("2", "0"): return ["vA"]
        case ("2", "1"): return ["<A"]
        case ("2", "A"): return [">vA", "v>A"]
        case ("2", "3"): return [">A"]
        case ("2", "4"): return ["^<A", "<^A"]
        case ("2", "5"): return ["^A"]
        case ("2", "6"): return ["^>A", ">^A"]
        case ("2", "7"): return ["^^<A", "<^^A"]
        case ("2", "8"): return ["^^A"]
        case ("2", "9"): return ["^^>A", ">^^A"]
            
        case ("3", "0"): return ["v<A", "<vA"]
        case ("3", "1"): return ["<<A"]
        case ("3", "2"): return ["<A"]
        case ("3", "A"): return ["vA"]
        case ("3", "4"): return ["^<<A", "<<^A"]
        case ("3", "5"): return ["^<A", "<^A"]
        case ("3", "6"): return ["^A"]
        case ("3", "7"): return ["^^<<A", "<<^^A"]
        case ("3", "8"): return ["^^<A", "<^^A"]
        case ("3", "9"): return ["^^A"]
            
        case ("4", "0"): return [">vvA"]
        case ("4", "1"): return ["vA"]
        case ("4", "2"): return [">vA", "v>A"]
        case ("4", "3"): return [">>vA", "v>>A"]
        case ("4", "A"): return [">>vvA"]
        case ("4", "5"): return [">A"]
        case ("4", "6"): return [">>A"]
        case ("4", "7"): return ["^A"]
        case ("4", "8"): return ["^>A", ">^A"]
        case ("4", "9"): return ["^>>A", ">>^A"]
            
        case ("5", "0"): return ["vvA"]
        case ("5", "1"): return ["v<A", "<vA"]
        case ("5", "2"): return ["vA"]
        case ("5", "3"): return ["v>A"]
        case ("5", "4"): return ["<A"]
        case ("5", "A"): return ["vv>A", ">vvA"]
        case ("5", "6"): return [">A"]
        case ("5", "7"): return ["^<A", "<^A"]
        case ("5", "8"): return ["^A"]
        case ("5", "9"): return ["^>A", ">^A"]
            
        case ("6", "0"): return ["vv<A", "<vvA"]
        case ("6", "1"): return ["v<<A", "<<vA"]
        case ("6", "2"): return ["v<A", "<vA"]
        case ("6", "3"): return ["vA"]
        case ("6", "4"): return ["<<A"]
        case ("6", "5"): return ["<A"]
        case ("6", "A"): return ["vvA"]
        case ("6", "7"): return ["^<<A", "<<^A"]
        case ("6", "8"): return ["^<A", "<^A"]
        case ("6", "9"): return ["^A"]
            
        case ("7", "0"): return [">vvvA"]
        case ("7", "1"): return ["vvA"]
        case ("7", "2"): return [">vvA", "vv>A"]
        case ("7", "3"): return [">>vvA", "vv>>A"]
        case ("7", "4"): return ["vA"]
        case ("7", "5"): return [">vA", "v>A"]
        case ("7", "6"): return [">>vA", "v>>A"]
        case ("7", "A"): return [">>vvvA"]
        case ("7", "8"): return [">A"]
        case ("7", "9"): return [">>A"]
            
        case ("8", "0"): return ["vvvA"]
        case ("8", "1"): return ["vv<A", "<vvA"]
        case ("8", "2"): return ["vvA"]
        case ("8", "3"): return ["vv>A", ">vvA"]
        case ("8", "4"): return ["v<A", "<vA"]
        case ("8", "5"): return ["vA"]
        case ("8", "6"): return ["v>A", ">vA"]
        case ("8", "7"): return ["<A"]
        case ("8", "A"): return ["vvv>A", ">vvvA"]
        case ("8", "9"): return [">A"]
            
        case ("9", "0"): return ["vvv<A", "<vvvA"]
        case ("9", "1"): return ["vv<<A", "<<vvA"]
        case ("9", "2"): return ["vv<A", "<vvA"]
        case ("9", "3"): return ["vvA"]
        case ("9", "4"): return ["v<<A", "<<vA"]
        case ("9", "5"): return ["v<A", "<vA"]
        case ("9", "6"): return ["vA"]
        case ("9", "7"): return ["<<A"]
        case ("9", "8"): return ["<A"]
        case ("9", "A"): return ["vvvA"]
            
        default: fatalError("Invalid combination: \(from), \(to)")
        }
    }
    
    /*
     +---+---+
     | ^ | A |
 +---+---+---+
 | < | v | > |
 +---+---+---+
     */
    func directionalPadRoute(from: Character, to: Character) -> [String] {
        guard from != to else { return ["A" ]}
        
        switch (from, to) {
        case ("A", "<"): return ["v<<A", "<<vA"]
        case ("A", "^"): return ["<A"]
        case ("A", ">"): return ["vA"]
        case ("A", "v"): return ["v<A", "<vA"]
            
        case ("<", "A"): return [">>^A", "^>>A"]
        case ("<", "^"): return [">^A", "^>A"]
        case ("<", ">"): return [">>A"]
        case ("<", "v"): return [">A"]
            
        case ("^", "<"): return ["v<A", "<vA"]
        case ("^", "A"): return [">A"]
        case ("^", ">"): return ["v>A", ">vA"]
        case ("^", "v"): return ["vA"]
            
        case (">", "<"): return ["<<A"]
        case (">", "^"): return ["<^A", "^<A"]
        case (">", "A"): return ["^A"]
        case (">", "v"): return ["<A"]
            
        case ("v", "<"): return ["<A"]
        case ("v", "^"): return ["^A"]
        case ("v", ">"): return [">A"]
        case ("v", "A"): return [">^A", "^>A"]
            
        default: fatalError("Invalid combination: \(from), \(to)")
        }
    }
}

public extension Day21 {
    static func generateSteps(str: String) -> [String: [String]] {
        let chars = str.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "X", with: "")
        let grid = Grid<String>(str.lines)
        var steps = [String: [String]]()
        for start in chars {
            for end in chars {
                steps[String(start) + String(end)] =
                generateSteps(map: grid.points, start: start, end: end)
            }
        }
        return steps
    }
    
    static func generateSteps(map: [Point: String], start: Character, end: Character, visited: Set<Character> = []) -> [String] {
        if start == end {
            return ["A"]
        }
        
        let startPoint = map.first { Character($0.value) == start }!.key
        var results = [String]()
        for dir in Direction.allCases {
            guard let next = map[startPoint + dir.point] else { continue }
            if next != "X" && !visited.contains(next) {
                let nextSteps = generateSteps(map: map, start: Character(next), end: end, visited: visited.union([start]))
                results.append(contentsOf: nextSteps.map {
                    dir.char + $0
                })
            }
        }
        
        return results
    }
}

extension Direction {
    var char: String {
        switch self {
        case .up: "^"
        case .right: ">"
        case .left: "<"
        case .down: "v"
        }
    }
}
