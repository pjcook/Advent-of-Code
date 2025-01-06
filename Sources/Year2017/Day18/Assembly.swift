extension Duet {
    // The tablet's assembly code, a program holding a list of instructions.
    public class Assembly {
        // The instruction set revision.
        // - v1 uses .play and .recover for snd respectively rcv,
        // - v2 uses .send and .receive for snd respectively rcv.
        public enum Revision { case v1, v2 }
        
        // An instruction from the tablet.
        public enum Instruction {
            // Either an integer or a register name.
            public enum Expression {
                case literal(Int)
                case identifier(Register)
                
                // Parse a given expression String. Returns nil on failure, an
                // Expression otherwise.
                static func parse(_ exp: String) -> Expression? {
                    guard exp.count > 0 else { return nil }
                    if let number = Int(exp) {
                        return .literal(number)
                    } else {
                        return .identifier(exp[exp.startIndex])
                    }
                }
                
                // Evaluate this expression. The fetch closure is used to get the value
                // from a register (if needed).
                func eval(fetch: (Register) -> Int) -> Int {
                    switch self {
                    case .literal(let number):
                        return number
                    case .identifier(let reg):
                        return fetch(reg)
                    }
                }
            }
            
            // v1 & v2 instructions
            case set(reg: Register, exp: Expression)
            case add(reg: Register, exp: Expression)
            case mul(reg: Register, exp: Expression)
            case mod(reg: Register, exp: Expression)
            case jgz(cond: Expression, offset: Expression)
            // v1 instructions
            case play(src: Expression)
            case recover(cond: Register)
            // v2 instructions
            case send(src: Expression)
            case receive(dest: Register)
            
            // Parse a given instruction String. Returns nil on failure, a new
            // Instruction otherwise. Different instructions are generated for both
            // `snd` and `rcv` depending on the requested revision of the instruction
            // set.
            static func parse(_ line: String, revision: Revision) -> Instruction? {
                let parts = line.split(separator: " ")
                switch parts[0] {
                case "snd":
                    let src = Expression.parse(String(parts[1]))!
                    switch revision {
                    case .v1: return .play(src: src)
                    case .v2: return .send(src: src)
                    }
                    
                case "rcv":
                    let reg = Register(parts[1])
                    switch revision {
                    case .v1: return .recover(cond: reg)
                    case .v2: return .receive(dest: reg)
                    }
                case "set": return.set(reg: Register(parts[1]), exp: Expression.parse(String(parts[2]))!)
                case "add": return.add(reg: Register(parts[1]), exp: Expression.parse(String(parts[2]))!)
                case "mul": return.mul(reg: Register(parts[1]), exp: Expression.parse(String(parts[2]))!)
                case "mod": return.mod(reg: Register(parts[1]), exp: Expression.parse(String(parts[2]))!)
                case "jgz": return.jgz(cond: Expression.parse(String(parts[1]))!, offset: Expression.parse(String(parts[2]))!)
                default: fatalError("Unknown opcode \(parts[0])")
                }
            }
        }
        
        public let instructions: [Instruction]
        
        // Parse a program, one instruction per line. Returns nil on parsing
        // failure.
        public convenience init?(_ revision: Revision, _ asm: String) {
            let lines = asm.split(separator: "\n").map(String.init)
            self.init(revision, lines)
        }
        
        // Parse a program, one instruction per element in the given lines. Returns
        // nil on failure to parse any of the line.
        public convenience init?(_ revision: Revision, _ lines: [String]) {
            var instructions: [Instruction] = []
            for line in lines {
                if let instruction = Instruction.parse(line, revision: revision) {
                    instructions.append(instruction)
                } else {
                    return nil
                }
            }
            self.init(instructions)
        }
        
        // Create a program given its list of instruction.
        private init(_ instructions: [Instruction]) {
            self.instructions = instructions
        }
    }
}
