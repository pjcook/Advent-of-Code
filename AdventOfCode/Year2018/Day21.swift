import Foundation

public class Day21 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        let eqrrPointer = input.firstIndex(where: { $0.hasPrefix("eqrr") })! - 1 // 28
        var instructions = OpCode.parse(input)
        var instructionPointer = 0
        let registerPointer = instructions.removeFirst().value
        var forceQuit = true
        var i = 0
        mainLoop: while forceQuit {
            i += 1
//            print(i)
            if i > 5 {
                break
            }
            
            var registers = [i,0,0,0,0,0]
            var cycles = 0
            while (0..<instructions.count).contains(instructionPointer) {
                let ip = instructionPointer
                registers[registerPointer] = ip
                let instruction = instructions[ip]
//                let originalRegisters = registers
                registers = instruction.operation!(registers, instruction.values)
                instructionPointer = registers[registerPointer] + 1
                if registers[registerPointer] == eqrrPointer { // because instruction 28 is eqrr which checks whether the answer is correct
//                    print("ip=\(ip) \(originalRegisters) \(instruction) \(registers)")
                    return registers[1]
                }
//                print("ip=\(ip) \(originalRegisters) \(instruction) \(registers)")
                cycles += 1
            }
            forceQuit = false
        }
        
        return i
    }
    
    // https://todd.ginsberg.com/post/advent-of-code/2018/day21/
    public func solve(_ input: [String], magicRegister: Int = 1) -> [Int] {
        let magicInstruction = input.firstIndex(where: { $0.hasPrefix("eqrr") })! - 1 // 28
        var instructions = OpCode.parse(input)
        
        var registers = [0,0,0,0,0,0]
        let ipBind = instructions.removeFirst().value
        var ip = registers[ipBind]
        var seen = Set<Int>()
        var yield = [Int]()
        while (0..<instructions.count).contains(ip) {
            registers[ipBind] = ip
            let instruction = instructions[ip]
            registers = instruction.operation!(registers, instruction.values)
            ip = registers[ipBind] + 1
            if ip == magicInstruction {
                let value = registers[magicRegister]
                if seen.contains(value) {
                    return yield
                } else {
                    print(value)
                    yield.append(value)
                }
                seen.insert(value)
            }
        }
        
        return []
    }
    
    // This is the Elf code converted into real code. Converting the GOTO's into this loop is super painful
    public func solve() -> [Int] {
        var b: Int = 10_905_776
        var c: Int = 65_536
        var d: Int = 0
        
        var seen = Set<Int>()
        var yield = [Int]()
        while true {
            d = c & 255
            b += d
            b = ((b % 16777216) * 65899) % 16777216
            
            if c < 256 {
                if seen.contains(b) {
                    return yield
                } else {
                    yield.append(b)
                    seen.insert(b)
                    c = b | 65536
                    b = 10_905_776
                }
            } else {
                d = 0
                if ((d + 1) * 256) > c {
                    c = d
                    d = 0
                } else {
                    d = 256
                    c /= d
                }
            }
        }
    }
}
