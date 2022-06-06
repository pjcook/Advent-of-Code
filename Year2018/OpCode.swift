import Foundation

public enum OpCode {
    public typealias Instructions = [Int]
    public typealias Registers = [Int]
    public typealias Operation = (Registers, Instructions) -> Registers
    
    public static func addr(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] + input[b]
        return input
    }

    public static func addi(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] + b
        return input
    }
    
    public static func mulr(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] * input[b]
        return input
    }
    
    public static func muli(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] * b
        return input
    }
    
    public static func banr(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] & input[b]
        return input
    }
    
    public static func bani(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] & b
        return input
    }
    
    public static func borr(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] | input[b]
        return input
    }
    
    public static func bori(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] | b
        return input
    }
    
    public static func setr(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let c = instruction[3]
        input[c] = input[a]
        return input
    }
    
    public static func seti(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let c = instruction[3]
        input[c] = a
        return input
    }
    
    public static func gtir(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = a > input[b] ? 1 : 0
        return input
    }
    
    public static func gtri(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] > b ? 1 : 0
        return input
    }
    
    public static func gtrr(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] > input[b] ? 1 : 0
        return input
    }
    
    public static func eqir(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = a == input[b] ? 1 : 0
        return input
    }
    
    public static func eqri(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] == b ? 1 : 0
        return input
    }
    
    public static func eqrr(_ input: Registers, _ instruction: Instructions) -> Registers {
        var input = input
        let a = instruction[1]
        let b = instruction[2]
        let c = instruction[3]
        input[c] = input[a] == input[b] ? 1 : 0
        return input
    }
}

extension OpCode {
    public static func parse(_ input: [String]) -> [Instruction] {
        return input.compactMap(Instruction.convert)
    }
    
    public enum Instruction {
        case ip(Int)
        case addr([Int])
        case addi([Int])
        case mulr([Int])
        case muli([Int])
        case banr([Int])
        case bani([Int])
        case borr([Int])
        case bori([Int])
        case setr([Int])
        case seti([Int])
        case gtir([Int])
        case gtri([Int])
        case gtrr([Int])
        case eqir([Int])
        case eqri([Int])
        case eqrr([Int])
        
        public var value: Int {
            switch self {
            case let .ip(value):
                return value
            default:
                return -1
            }
        }
        
        public var values: [Int] {
            switch self {
            case let .addr(values): return values
            case let .addi(values): return values
            case let .mulr(values): return values
            case let .muli(values): return values
            case let .banr(values): return values
            case let .bani(values): return values
            case let .borr(values): return values
            case let .bori(values): return values
            case let .setr(values): return values
            case let .seti(values): return values
            case let .gtir(values): return values
            case let .gtri(values): return values
            case let .gtrr(values): return values
            case let .eqir(values): return values
            case let .eqri(values): return values
            case let .eqrr(values): return values
            default: return []
            }
        }
        
        public var operation: OpCode.Operation? {
            switch self {
            case .addr: return OpCode.addr
            case .addi: return OpCode.addi
            case .mulr: return OpCode.mulr
            case .muli: return OpCode.muli
            case .banr: return OpCode.banr
            case .bani: return OpCode.bani
            case .borr: return OpCode.borr
            case .bori: return OpCode.bori
            case .setr: return OpCode.setr
            case .seti: return OpCode.seti
            case .gtir: return OpCode.gtir
            case .gtri: return OpCode.gtri
            case .gtrr: return OpCode.gtrr
            case .eqir: return OpCode.eqir
            case .eqri: return OpCode.eqri
            case .eqrr: return OpCode.eqrr
            default: return nil
            }
        }
        
        public static func convert(_ input: String) -> Instruction? {
            if input.hasPrefix("#ip") {
                let value = Int(input.replacingOccurrences(of: "#ip ", with: ""))!
                return .ip(value)
            } else if input.hasPrefix("addr") {
                let values = input.replacingOccurrences(of: "addr ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .addr([0] + values)
            } else if input.hasPrefix("addi") {
                let values = input.replacingOccurrences(of: "addi ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .addi([0] + values)
            } else if input.hasPrefix("mulr") {
                let values = input.replacingOccurrences(of: "mulr ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .mulr([0] + values)
            } else if input.hasPrefix("muli") {
                let values = input.replacingOccurrences(of: "muli ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .muli([0] + values)
            } else if input.hasPrefix("banr") {
                let values = input.replacingOccurrences(of: "banr ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .banr([0] + values)
            } else if input.hasPrefix("bani") {
                let values = input.replacingOccurrences(of: "bani ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .bani([0] + values)
            } else if input.hasPrefix("borr") {
                let values = input.replacingOccurrences(of: "borr ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .borr([0] + values)
            } else if input.hasPrefix("bori") {
                let values = input.replacingOccurrences(of: "bori ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .bori([0] + values)
            } else if input.hasPrefix("setr") {
                let values = input.replacingOccurrences(of: "setr ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .setr([0] + values)
            } else if input.hasPrefix("seti") {
                let values = input.replacingOccurrences(of: "seti ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .seti([0] + values)
            } else if input.hasPrefix("gtir") {
                let values = input.replacingOccurrences(of: "gtir ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .gtir([0] + values)
            } else if input.hasPrefix("gtri") {
                let values = input.replacingOccurrences(of: "gtri ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .gtri([0] + values)
            } else if input.hasPrefix("gtrr") {
                let values = input.replacingOccurrences(of: "gtrr ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .gtrr([0] + values)
            } else if input.hasPrefix("eqir") {
                let values = input.replacingOccurrences(of: "eqir ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .eqir([0] + values)
            } else if input.hasPrefix("eqri") {
                let values = input.replacingOccurrences(of: "eqri ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .eqri([0] + values)
            } else if input.hasPrefix("eqrr") {
                let values = input.replacingOccurrences(of: "eqrr ", with: "").components(separatedBy: " ").map { Int($0)! }
                return .eqrr([0] + values)
            }
            
            return nil
        }
    }
}
