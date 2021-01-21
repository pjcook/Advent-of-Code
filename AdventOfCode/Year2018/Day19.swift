import Foundation

public struct Day19 {
    public init() {}
    
    public func solve(_ input: [String], registers: [Int] = [0,0,0,0,0,0], maxCycles: Int = 0) -> Int {
        var instructions = OpCode.parse(input)
        var instructionPointer = 0
        var registers = registers
        let registerPointer = instructions.removeFirst().value
        var cycles = 0
//        var lastFirstRegister = registers[0]
        while (0..<instructions.count).contains(instructionPointer) {
            let ip = instructionPointer
            registers[registerPointer] = ip
            let instruction = instructions[ip]
//            let originalRegisters = registers
            registers = instruction.operation!(registers, instruction.values)
            instructionPointer = registers[registerPointer] + 1
//            if registers[0] != lastFirstRegister {
//                lastFirstRegister = registers[0]
//                print("ip=\(ip) \(originalRegisters) \(instruction) \(registers)")
//            }
            cycles += 1
            if maxCycles > 0 && cycles >= maxCycles {
                break
            }
        }
        
        if maxCycles > 0 {
            return registers.sorted().last!
        } else {
            return registers[0]
        }
    }
    
    public func part2(_ input: [String]) -> Int {
        let n = solve(input, registers: [1,0,0,0,0,0], maxCycles: 1000)
        var total = 0
        for i in (1..<n+1) {
            if n % i == 0 {
                total += i
            }
        }
        return total
    }
}
