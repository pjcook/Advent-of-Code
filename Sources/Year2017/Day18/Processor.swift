extension Duet {
    // A Central Processor Unit able to execute the assembly code found on the
    // tablet.
    public class Processor {
        // A special register initially holding the processor's id.
        static let ID_REGISTER: Register = "p"
        
        // Type of event emmited by the CPU.
        public enum Event { case recover, send }
        
        // Function type used as event callback by the processor.
        public typealias Callback = (Int?) -> Execution
        
        // The CPU execution state.
        public enum Execution { case proceed, wait, stop }
        
        let id: Int                            // this processor's ID
        let program: Assembly                  // the program to execute.
        var registers: [Register: Int] = [:]   // the processor's registers.
        let default_value: Int = 0             // default register value.
        var state: Execution = .proceed        // execution flow state.
        var pc: Int = 0                        // program counter.
        var listeners: [Event: Callback] = [:] // registered callback per event.
        var sound: Int? = nil                  // The last played sound.
        var messages: [Int] = []               // FIFO message queue for this CPU.
        
        // Create a new processor given its id. The Processor.ID_REGISTER will be
        // initially set to the processor id.
        public init(id: Int = 0, program: Assembly) {
            self.id = id
            self.program = program
            self[Processor.ID_REGISTER] = Int(id)
        }
        
        // Register the given callback function to be called when the provided
        // event arise. Returns the callback previously setup for the event if any.
        @discardableResult
        public func on(_ event: Event, callback: @escaping Callback) -> Callback? {
            let old = listeners[event]
            listeners[event] = callback
            return old
        }
        
        // Execute the program on this processor.
        public func run() {
            while let current = instruction {
                execute(current)
                if !advance() {
                    // Here we did not made progress by executing the current
                    // instruction, i.e. we're waiting. Explicitely break the loop since
                    // we still do have a next instruction (the same as the current).
                    break
                }
            }
        }
        
        // Send the given message to this CPU.
        public func notify(msg: Int) {
            messages.append(msg)
        }
        
        // True if this CPU is waiting to receive a message, false otherwise.
        public var is_waiting: Bool {
            return state == .wait && messages.count == 0
        }
        
        // True if this CPU is stopped, false otherwise.
        public var is_stopped: Bool {
            return state == .stop
        }
        
        // Execute a given instruction on this processor.
        private func execute(_ instruction: Assembly.Instruction) {
            // syntaxic sugar to evaluate an Expression.
            func eval(_ expression: Assembly.Instruction.Expression) -> Int {
                return expression.eval(fetch: { self[$0] })
            }
            switch instruction {
                // v1 & v2 instructions
            case .set(let reg, let exp):
                self[reg] = eval(exp)
            case .add(let reg, let exp):
                self[reg] = self[reg] + eval(exp)
            case .mul(let reg, let exp):
                self[reg] = self[reg] * eval(exp)
            case .mod(let reg, let exp):
                self[reg] = self[reg] % eval(exp)
            case .jgz(let cond, let offset):
                if eval(cond) > 0 {
                    // NOTE: minus one because the pc will be advanced by one after the jump
                    // instruction execution.
                    pc += Int(eval(offset) - 1)
                }
                // v1 instructions
            case .play(let src):
                sound = eval(src)
            case .recover(let cond):
                if self[cond] != 0 {
                    guard let on_recover = listeners[.recover] else { return }
                    state = on_recover(sound)
                }
                // v2 instructions are implemented with the CPU messages queue: the
                // send instruction only call the listener (if any) and the receive
                // instruction consume the first element from the queue (if any).
            case .send(let src):
                guard let on_send = listeners[.send] else { return }
                state = on_send(eval(src))
            case .receive(let dest):
                if let value = messages.first {
                    // We got a message, consume it and set the destination register
                    // with the message's value.
                    messages.removeFirst()
                    self[dest] = value
                    // When we retry a .receive instruction we are in .wait state. Now
                    // that we got our message let's .proceed again (NOTE: we could
                    // also just be .proceed'ing here)
                    state = .proceed
                } else {
                    // We don't have a message to consume for our .receive instruction.
                    // Let's .wait and retry this instruction on the next run.
                    state = .wait
                }
            }
        }
        
        // Advance the program counter if we are not waiting nor stopped. Then,
        // stop if we've reached the end of the program. Returns true if the
        // program counter has changed, false otherwise.
        private func advance() -> Bool {
            guard state == .proceed else { return false }
            pc += 1
            // Check against zero just to be sure, (e.g. bad jump).
            if !(0..<program.instructions.count).contains(pc) {
                state = .stop
            }
            return true
        }
        
        // The instruction to be executed by the CPU, if any.
        private var instruction: Assembly.Instruction? {
            guard state != .stop else { return nil }
            return program.instructions[pc]
        }
        
        // Shortcut to get & set registers, honoring the configured default value
        // when a register has none.
        private subscript(_ reg: Register) -> Int {
            get {
                return registers[reg, default: default_value]
            }
            set(newValue) {
                registers[reg] = newValue
            }
        }
    }
}
