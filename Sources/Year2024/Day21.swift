import Foundation
import StandardLibraries

public class Day21 {
    public init() {}
    
    private var cache = [String: [String]]()
    
    public func part1(_ input: [String], chainLength: Int) -> Int {
        var result = 0
        
        for line in input {
            let instructions = convertInputToInstructions(line, chainLength: chainLength)
            let value = Int(line.replacingOccurrences(of: "A", with: ""))!
            print(line, value, instructions.count, instructions)
            result += instructions.count * value
        }
        
        return result
    }
}

extension Day21 {
    func convertInputToInstructions(_ input: String, chainLength: Int) -> String {
        var instructions = ["", ""]
        var current = Character("A")
        var remaining = input
        
        while !remaining.isEmpty {
            let next = remaining.removeFirst()
            let options = numberPadRoute(from: current, to: next)
            
            let option1 = options[0]
            let option2 = options.count == 1 ? option1 : options[1]
            
            instructions[0] = instructions[0] + option1
            instructions[1] = instructions[1] + option2
            
            current = next
        }
        
        for i in (0..<chainLength) {
            print("Chained iteration", i, instructions.count, cache.count)
            instructions = calculateChainedRobotInstructions(instructions: instructions)
        }
        
        return instructions.sorted(by: { $0.count < $1.count }).first!
    }
    
    func calculateChainedRobotInstructions(instructions: [String]) -> [String] {
        let instructionSet = Set(instructions)
        var instructions2 = Set<String>()
        for instruction in instructionSet {
            var current = Character("A")
            var instruction = instruction
            var a = ""
            var b = ""
            
            while !instruction.isEmpty {
                let next = instruction.removeFirst()
                let options = directionalPadRoute(from: current, to: next)
                
                let option1 = options[0]
                let option2 = options.count == 1 ? option1 : options[1]
                a = a + option1
                b = b + option2
                current = next
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
        
        return Array(instructions2)
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
