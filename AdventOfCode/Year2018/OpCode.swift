import Foundation

public struct OpCode {
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
