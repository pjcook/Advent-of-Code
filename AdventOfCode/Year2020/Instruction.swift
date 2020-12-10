import Foundation
import StandardLibraries

public enum Instruction {
    case acc(Int)
    case jmp(Int)
    case nop(Int)
    
    var flipped: Self {
        switch self {
        case .acc: return self
        case .jmp(let value): return .nop(value)
        case .nop(let value): return .jmp(value)
        }
    }
    
    public static func parse(_ input: String) -> Instruction? {
        let parts = input.components(separatedBy: " ")
        switch parts[0] {
        case "acc":
            return Instruction.acc(Int(parts[1])!)
        case "jmp":
            return Instruction.jmp(Int(parts[1])!)
        case "nop":
            return Instruction.nop(Int(parts[1])!)
        default:
            return nil
        }
    }
    
    static let regex = try! RegularExpression(pattern: #"([a-z]{3}) ([+\-0-9]+)"#)
    public static func parse2(_ input: String) -> Instruction? {
        let match = try! regex.match(input)
        let value = try! match.integer(at: 1)
        switch try! match.string(at: 0) {
        case "acc": return .acc(value)
        case "jmp": return .jmp(value)
        case "nop": return .nop(value)
        default: return nil
        }
    }
}
