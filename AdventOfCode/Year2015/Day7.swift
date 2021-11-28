import Foundation
import StandardLibraries

public struct Day7 {
    public init() {}
    public typealias ID = String
    
    public static let literalRegex = try! RegularExpression(pattern: "^([\\d]+) -> ([\\w]+)$")
    public static let passthroughRegex = try! RegularExpression(pattern: "^([\\w]+) -> ([\\w]+)$")
    public static let lshiftRegex = try! RegularExpression(pattern: "^([\\w]+) LSHIFT ([\\w]+) -> ([\\w]+)$")
    public static let rshiftRegex = try! RegularExpression(pattern: "^([\\w]+) RSHIFT ([\\w]+) -> ([\\w]+)$")
    public static let andRegex = try! RegularExpression(pattern: "^([\\w]+) AND ([\\w]+) -> ([\\w]+)$")
    public static let orRegex = try! RegularExpression(pattern: "^([\\w]+) OR ([\\w]+) -> ([\\w]+)$")
    public static let notRegex = try! RegularExpression(pattern: "^NOT ([\\w]+) -> ([\\w]+)$")
    
    public enum Command {
        case literal(Int)
        case passthrough(ID)
        case lshift(ID,Int)
        case rshift(ID,Int)
        case and(ID,ID)
        case or(ID,ID)
        case not(ID)
    }
    
    public class Instruction {
        public let id: ID
        public var outputValue: Int?
        public let command: Command
        
        public init(id: ID, outputValue: Int?, command: Command) {
            self.id = id
            self.outputValue = outputValue
            self.command = command
        }
    }
    
    public func part1(_ input: [String], calculate: ID) throws -> Int {
        let instructions = try parse(input)
        guard let instruction = instructions[calculate] else { return 0 }
        return resolve(instruction, instructions: instructions)
    }
    
    public func resolve(_ instruction: Instruction, instructions: [ID:Instruction]) -> Int {
        if let value = instruction.outputValue {
            return value
        }
        
        switch instruction.command {
        case let .literal(value):
            return value
            
        case let .passthrough(id):
            let value = Int(id) ?? resolve(instructions[id]!, instructions: instructions)
            instruction.outputValue = value
            return instruction.outputValue!
            
        case let .lshift(id, value1):
            let value2 = Int(id) ?? resolve(instructions[id]!, instructions: instructions)
            instruction.outputValue = value2 << value1
            return instruction.outputValue!
            
        case let .rshift(id, value1):
            let value2 = Int(id) ?? resolve(instructions[id]!, instructions: instructions)
            instruction.outputValue = value2 >> value1
            return instruction.outputValue!
            
        case let .and(id1, id2):
            let value1 = Int(id1) ?? resolve(instructions[id1]!, instructions: instructions)
            let value2 = Int(id2) ?? resolve(instructions[id2]!, instructions: instructions)
            instruction.outputValue = value1 & value2
            return instruction.outputValue!
            
        case let .or(id1, id2):
            let value1 = Int(id1) ?? resolve(instructions[id1]!, instructions: instructions)
            let value2 = Int(id2) ?? resolve(instructions[id2]!, instructions: instructions)
            instruction.outputValue = value1 | value2
            return instruction.outputValue!
            
        case let .not(id):
            let value = Int(id) ?? resolve(instructions[id]!, instructions: instructions)
            instruction.outputValue = 65536 + ~value
            return instruction.outputValue!
        }
    }
    
    public func parse(_ input: [String]) throws -> [ID: Instruction] {
        var instructions = [ID: Instruction]()
        for line in input {
            do {
            if let match = try? Self.literalRegex.match(line) {
                let id = try match.string(at: 1)
                let value = try match.integer(at: 0)
                instructions[id] = Instruction(id: id, outputValue: value, command: .literal(value))
                
            } else if let match = try? Self.passthroughRegex.match(line) {
                let id = try match.string(at: 1)
                let commandID = try match.string(at: 0)
                instructions[id] = Instruction(id: id, outputValue: nil, command: .passthrough(commandID))
                
            } else if let match = try? Self.lshiftRegex.match(line) {
                let id = try match.string(at: 2)
                let commandID = try match.string(at: 0)
                let value = try match.integer(at: 1)
                instructions[id] = Instruction(id: id, outputValue: nil, command: .lshift(commandID, value))
                
            } else if let match = try? Self.rshiftRegex.match(line) {
                let id = try match.string(at: 2)
                let commandID = try match.string(at: 0)
                let value = try match.integer(at: 1)
                instructions[id] = Instruction(id: id, outputValue: nil, command: .rshift(commandID, value))
                
            } else if let match = try? Self.andRegex.match(line) {
                let id = try match.string(at: 2)
                let commandID1 = try match.string(at: 0)
                let commandID2 = try match.string(at: 1)
                instructions[id] = Instruction(id: id, outputValue: nil, command: .and(commandID1, commandID2))
                
            } else if let match = try? Self.orRegex.match(line) {
                let id = try match.string(at: 2)
                let commandID1 = try match.string(at: 0)
                let commandID2 = try match.string(at: 1)
                instructions[id] = Instruction(id: id, outputValue: nil, command: .or(commandID1, commandID2))
                
            } else if let match = try? Self.notRegex.match(line) {
                let id = try match.string(at: 1)
                let commandID1 = try match.string(at: 0)
                instructions[id] = Instruction(id: id, outputValue: nil, command: .not(commandID1))
            }
            } catch {
                print(line, error)
            }
        }
        
        return instructions
    }
}
