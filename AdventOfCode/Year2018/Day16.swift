import Foundation
import StandardLibraries

public struct Day16 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let calculations = [
            OpCode.addr, OpCode.addi,
            OpCode.mulr, OpCode.muli,
            OpCode.banr, OpCode.bani,
            OpCode.borr, OpCode.bori,
            OpCode.setr, OpCode.seti,
            OpCode.gtir, OpCode.gtri, OpCode.gtrr,
            OpCode.eqir, OpCode.eqri, OpCode.eqrr
        ]
        
        let (manual, _) = parse(input)
        
        var count = 0
        outerloop: for sample in manual.samples {
            var calculationCount = 0
            for calculation in calculations {
                if calculation(sample.before, sample.program) == sample.after {
                    calculationCount += 1
                    if calculationCount >= 3 {
                        count += 1
                        continue outerloop
                    }
                }
            }
            if calculationCount >= 3 {
                count += 1
            }
        }
        
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        let calculations = [
            "addr": OpCode.addr,
            "addi": OpCode.addi,
            "mulr": OpCode.mulr,
            "muli": OpCode.muli,
            "banr": OpCode.banr,
            "bani": OpCode.bani,
            "borr": OpCode.borr,
            "bori": OpCode.bori,
            "setr": OpCode.setr,
            "seti": OpCode.seti,
            "gtir": OpCode.gtir,
            "gtri": OpCode.gtri,
            "gtrr": OpCode.gtrr,
            "eqir": OpCode.eqir,
            "eqri": OpCode.eqri,
            "eqrr": OpCode.eqrr
        ]
        
        let (manual, instructions) = parse(input)
        
        var mappings = [Int:Set<String>]()
        for sample in manual.samples {
            for calculation in calculations {
                if calculation.value(sample.before, sample.program) == sample.after {
                    mappings[sample.program[0], default: Set<String>()].insert(calculation.key)
                }
            }
        }
        
        var mappedCalculations = [Int:String]()
        while !mappings.isEmpty {
            guard let result = mappings.first(where: { $0.value.count == 1 }) else {
                assertionFailure()
                return -1
            }
            let calculation = result.value.first!
            mappedCalculations[result.key] = calculation
            
            mappings.removeValue(forKey: result.key)
            
            for mapping in mappings {
                if let index = mapping.value.firstIndex(where: { $0 == calculation }) {
                    var values = mapping.value
                    values.remove(at: index)
                    mappings[mapping.key] = values
                }
            }
        }
        
        var result = instructions[0]
        for i in (1..<instructions.count) {
            let instruction = instructions[i]
            let calculationKey = mappedCalculations[instruction[0]]!
            let calculation = calculations[calculationKey]!
            result = calculation(result, instruction)
        }
        
        return result.first!
    }
}

extension Day16 {
    public func parse(_ input: [String]) -> (Manual, [OpCode.Registers]) {
        let beforeRegEx = try! RegularExpression(pattern: #"Before:\s\[([\d]*),\s([\d]*),\s([\d]*),\s([\d]*)\]"#)
        let afterRegEx = try! RegularExpression(pattern: #"After:\s\s\[([\d]*),\s([\d]*),\s([\d]*),\s([\d]*)\]"#)
        var samples = [Sample]()
        
        var blank = false
        var i = 0
        var before = OpCode.Registers()
        var program = OpCode.Instructions()
        var after = OpCode.Registers()
        for line in input {
            i += 1
            if blank && line.isEmpty {
                break
            } else if line.isEmpty {
                blank = true
                continue
            }
            blank = false
            if let beforeMatch = try? beforeRegEx.match(line) {
                before = OpCode.Registers()
                before.append(try! beforeMatch.integer(at: 0))
                before.append(try! beforeMatch.integer(at: 1))
                before.append(try! beforeMatch.integer(at: 2))
                before.append(try! beforeMatch.integer(at: 3))
            } else if let afterMatch = try? afterRegEx.match(line) {
                after = OpCode.Registers()
                after.append(try! afterMatch.integer(at: 0))
                after.append(try! afterMatch.integer(at: 1))
                after.append(try! afterMatch.integer(at: 2))
                after.append(try! afterMatch.integer(at: 3))
                samples.append(Sample(before: before, program: program, after: after))
            } else {
                program = line.components(separatedBy: " ").map { Int($0)! }
            }
        }
        
        for _ in (i..<input.count) {
            if input[i].isEmpty {
                i += 1
            } else {
                break
            }
        }
        
        var instructions = [OpCode.Registers]()
        for i in (i..<input.count) {
            let line = input[i]
            if !line.isEmpty {
                instructions.append(line.components(separatedBy: " ").map { Int($0)! })
            }
        }
        
        return (Manual(samples: samples), instructions)
    }

    public struct Manual {
        public let samples: [Sample]
        public init(samples: [Sample]) {
            self.samples = samples
        }
    }
    
    public struct Sample {
        public let before: OpCode.Registers
        public let program: OpCode.Instructions
        public let after: OpCode.Registers
        
        public init(before: OpCode.Registers, program: OpCode.Instructions, after: OpCode.Registers) {
            self.before = before
            self.program = program
            self.after = after
        }
    }
}
