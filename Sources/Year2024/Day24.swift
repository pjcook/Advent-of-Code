import Foundation
import StandardLibraries

public struct Day24 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var (registers, operations) = parse(input)

        while true {
            var hasChanged = false
            for operation in operations {
                guard let a = registers[operation.id1],
                      let b = registers[operation.id2] else {
                    hasChanged = true
                    continue
                }
                let next = operation.op.operate(a: a, b: b)
                if next != registers[operation.output] {
                    hasChanged = true
                }
                registers[operation.output] = next
            }
            
            if !hasChanged {
                break
            }
        }
        
        let bits = registers.keys.filter { $0.hasPrefix("z") }.sorted(by: >).map { String(registers[$0]!) }.joined()
        return Int(bits, radix: 2)!
    }
      
    // https://www.youtube.com/watch?v=SU6lp6wyd3I
    public func part2(_ input: [String]) -> String {
        let (_, operations) = parse(input)
        var formulas = [String: Operation]()
        for operation in operations {
            formulas[operation.output] = operation
        }
                
        var results = [String]()
        for _ in 0..<4 {
            var baseline = progress(formulas: formulas)
            outerLoop: for x in formulas.keys {
                for y in formulas.keys {
                    if x == y { continue }
                    swap(id1: x, id2: y, formulas: &formulas)
                    let current = progress(formulas: formulas)
                    if current > baseline {
                        baseline = current
                        print(current, x, y)
                        results.append(x)
                        results.append(y)
                        break outerLoop
                    }
                    swap(id1: x, id2: y, formulas: &formulas)
                }
            }
        }
        
        return results.sorted().joined(separator: ",")
    }
    
    /*
     AND gates output 1 if both inputs are 1; if either input is 0, these gates output 0.
     OR gates output 1 if one or both inputs is 1; if both inputs are 0, these gates output 0.
     XOR gates output 1 if the inputs are different; if the inputs are the same, these gates output 0.
     */
    enum Op: String {
        case AND
        case OR
        case XOR
        
        func operate(a: Int, b: Int) -> Int {
            switch self {
            case .AND: return a == 1 && b == 1 ? 1 : 0
            case .OR: return a == 0 && b == 0 ? 0 : 1
            case .XOR: return a == b ? 0 : 1
            }
        }
    }
    
    struct Operation {
        let id1: String
        let id2: String
        let op: Op
        let output: String
    }
}

extension Day24 {
    func progress(formulas: [String: Operation]) -> Int {
        var i = 0
        while true {
            if !verify(i, formulas: formulas) {
                break
            }
            i += 1
        }
        return i
    }
    
    func swap(id1: String, id2: String, formulas: inout [String: Operation]) {
        let a = formulas[id1]!
        let b = formulas[id2]!
        formulas[id2] = a
        formulas[id1] = b
    }
    
    func verify(_ num: Int, formulas: [String: Operation]) -> Bool {
        verifyZ(makeWire("z", num), num: num, formulas: formulas)
    }
    
    func makeWire(_ char: String, _ num: Int) -> String {
        char + num.padToString(length: 2)
    }
    
    func verifyZ(_ wire: String, num: Int, formulas: [String: Operation]) -> Bool {
//        print("vz", wire, num)
        guard let operation = formulas[wire] else { return false }
        guard operation.op == .XOR else { return false }
        if num == 0 { return [operation.id1, operation.id2].sorted() == ["x00", "y00"] }
        return verifyIntermediateXOR(operation.id1, num: num, formulas: formulas) && verifyCarryBit(operation.id2, num: num, formulas: formulas) || verifyIntermediateXOR(operation.id2, num: num, formulas: formulas) && verifyCarryBit(operation.id1, num: num, formulas: formulas)
    }
    
    func verifyIntermediateXOR(_ wire: String, num: Int, formulas: [String: Operation]) -> Bool {
//        print("vx", wire, num)
        guard let operation = formulas[wire] else { return false }
        guard operation.op == .XOR else { return false }
        return [operation.id1, operation.id2].sorted() == [makeWire("x", num), makeWire("y", num)]
    }
    
    func verifyCarryBit(_ wire: String, num: Int, formulas: [String: Operation]) -> Bool {
//        print("vc", wire, num)
        guard let operation = formulas[wire] else { return false }
        
        if num == 1 {
            return operation.op == .AND && [operation.id1, operation.id2].sorted() == ["x00", "y00"]
        }
        
        guard operation.op == .OR else { return false }
        return verifyDirectCarry(operation.id1, num: num - 1, formulas: formulas) && verifyRecarry(operation.id2, num: num - 1, formulas: formulas) || verifyDirectCarry(operation.id2, num: num - 1, formulas: formulas) && verifyRecarry(operation.id1, num: num - 1, formulas: formulas)
    }
    
    func verifyDirectCarry(_ wire: String, num: Int, formulas: [String: Operation]) -> Bool {
//        print("vd", wire, num)
        guard let operation = formulas[wire] else { return false }
        guard operation.op == .AND else { return false }
        return [operation.id1, operation.id2].sorted() == [makeWire("x", num), makeWire("y", num)]
    }
    
    func verifyRecarry(_ wire: String, num: Int, formulas: [String: Operation]) -> Bool {
//        print("vr", wire, num)
        guard let operation = formulas[wire] else { return false }
        guard operation.op == .AND else { return false }
        return verifyIntermediateXOR(operation.id1, num: num, formulas: formulas) && verifyCarryBit(operation.id2, num: num, formulas: formulas) || verifyIntermediateXOR(operation.id2, num: num, formulas: formulas) && verifyCarryBit(operation.id1, num: num, formulas: formulas)
    }
    
    func drawTree(_ wire: String, depth: Int, formulas: [String: Operation]) -> String {
        if wire.hasPrefix("x") || wire.hasPrefix("y") {
            return String(repeating: "  ", count: depth) + wire
        }
        
        let operation = formulas[wire]!
        return String(repeating: "  ", count: depth) + operation.op.rawValue + " (" + wire + ")\n" + drawTree(operation.id1, depth: depth + 1, formulas: formulas) + "\n" + drawTree(operation.id2, depth: depth + 1, formulas: formulas)
    }
    
    func parse(_ input: [String]) -> ([String: Int], [Operation]) {
        var registers: [String: Int] = [:]
        var operations: [Operation] = []
        var foundRegisters = false
        
        for line in input {
            if line.isEmpty && !foundRegisters {
                foundRegisters = true
                continue
            }
            
            switch foundRegisters {
            case false:
                // x00: 1
                let components = line.split(separator: ": ")
                registers[String(components[0])] = Int(String(components[1]))!
                
            case true:
                // x00 AND y00 -> z00
                let components = line.replacingOccurrences(of: " -> ", with: " ").split(separator: " ")
                let output = String(components[3])
                let op = Operation(id1: String(components[0]), id2: String(components[2]), op: Op(rawValue: String(components[1]))!, output: output)
                operations.append(op)
            }
        }
        
        return (registers, operations)
    }
}
