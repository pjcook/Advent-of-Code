//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day18 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let operations = input.map { OpCode($0, version: .v1) }
        var registers: Registers = [:]
        var i = 0
        var lastSound = 0
        
        mainLoop: while true {
            var jumped = false
            var recover = false
            
            registers = operations[i].execute(on: registers) { value in
                lastSound = value
            } send: { _ in
            } recover: { value in
                recover = true
            } receive: { _, _ in
            } jump: { value in
                i += value
                jumped = true
            }

            if recover {
                return lastSound
            }
            
            if !jumped {
                i += 1
            }
        }
    }
    
    public func part1b(_ input: [String]) -> Int {
        let operations = input.map { OpCode($0, version: .v1) }
        let machine = Machine(operations: operations)
        machine.run()
        return machine.receive
    }
    
    public func part2b(_ input: [String]) -> Int {
        let operations = input.map { OpCode($0, version: .v2) }
        let queue1 = BasicQueue()
        let queue2 = BasicQueue()
        let machine1 = Machine2(operations: operations, registers: ["p": 0], send: queue1, receive: queue2)
        let machine2 = Machine2(operations: operations, registers: ["p": 1], send: queue2, receive: queue1)
        
        var i = 0
        while machine1.isRunning || machine2.isRunning {
            i += 1
            machine1.tick()
            machine2.tick()

            if i % 1000000 == 0 {
                print(i, queue1.count, queue2.count, machine2.sent, machine1.step, machine2.step)
            }
        }
        
        return machine2.sent
    }
    
    public func part2(_ input: [String]) -> Int {
        let operations = input.map { OpCode($0, version: .v2) }
        let programA = Program(id: "A", operations: operations, registers: ["p": 0])
        let programB = Program(id: "B", operations: operations, registers: ["p": 1])
        programA.delegate = programB
        programB.delegate = programA
        
        defer {
            programA.delegate = nil
            programB.delegate = nil
        }
        
        var i = 0
        while programA.state == .running || programB.state == .running {
            i += 1
            if i % 1000000 == 0 {
                print(i, programB.sendCount, programA.key, programB.key)
            }
            programA.tick()
            programB.tick()
        }
                
        return programB.sendCount
    }
    
    final class Machine {
        let operations: [OpCode]
        var registers: Registers
        var index = 0
        var send = 0
        var receive = 0
        
        init(operations: [OpCode], registers: Registers = [:]) {
            self.operations = operations
            self.registers = registers
        }
        
        func execute(instruction: OpCode) {
            switch instruction {
            case let .send(value), let .play(value):
                send = value.value(with: registers)
                
            case let .set(register, value):
                registers[register] = value.value(with: registers)
                
            case let .add(register, value):
                registers[register] = registers[register, default: 0] + value.value(with: registers)
                
            case let .multiply(register, value):
                registers[register] = registers[register, default: 0] * value.value(with: registers)
                
            case let .mod(register, value):
                registers[register] = registers[register, default: 0] % value.value(with: registers)
            
            case let .recover(register):
                if registers[register, default: 0] != 0 {
                    receive = send
                }
                
            case let .receive(register):
                if registers[register, default: 0] != 0 {
                    receive = send
                }

            case let .jump(register, value):
                if registers[register, default: 0] > 0 {
                    index += value.value(with: registers) - 1
                }
            }
            index += 1
        }
        
        func run() {
            while index < operations.count && receive == 0 {
                execute(instruction: operations[index])
            }
        }
    }
    
    final class BasicQueue {
        var queue = [Int]()
        
        var isEmpty: Bool {
            queue.isEmpty
        }
        
        var count: Int {
            queue.count
        }
        
        func enqueue(_ value: Int) {
            queue.append(value)
        }
        
        func dequeue() -> Int? {
            guard !queue.isEmpty else { return nil }
            return queue.removeFirst()
        }
    }
    final class Machine2 {
        enum State {
            case stopped, running, waiting
        }
        
        let operations: [OpCode]
        var registers: Registers
        var index = 0
        var lastSoundPlayed = 0
        var recovered = 0
        var sent = 0
        var send: BasicQueue
        var receive: BasicQueue
        var state: State = .running
        var step = 0
        
        var isRunning: Bool {
            state == .running
        }
        
        var isWaiting: Bool {
            state == .waiting
        }
        
        init(operations: [OpCode], registers: Registers, send: BasicQueue, receive: BasicQueue) {
            self.operations = operations
            self.registers = registers
            self.send = send
            self.receive = receive
        }
        
        func tick() {
            guard isRunning, (0..<operations.count).contains(index) else {
                state = .stopped
                return
            }
            step += 1
            execute(instruction: operations[index])
        }
        
        func execute(instruction: OpCode) {
            switch instruction {
            case let .play(value):
                lastSoundPlayed = getValue(for: value)
                
            case let .send(value):
                sent += 1
                send.enqueue(getValue(for: value))
                
            case let .set(register, value):
                registers[register] = getValue(for: value)
                
            case let .add(register, value):
                registers[register] = getValue(for: register) + getValue(for: value)
                
            case let .multiply(register, value):
                registers[register] = getValue(for: register) * getValue(for: value)
                
            case let .mod(register, value):
                registers[register] = getValue(for: register) % getValue(for: value)
                
            case let .recover(register):
                if registers[register] != 0 {
                    recovered = lastSoundPlayed
                    state = .stopped
                }
                
            case let .receive(register):
                if let value = receive.dequeue() {
                    registers[register] = value
                } else {
                    index -= 1
                    step -= 1
                }
            
            case let .jump(register, value):
                if getValue(for: register) > 0 {
                    index += getValue(for: value) - 1
                }
            }
            index += 1
        }
        
        func getValue(for register: Register) -> Int {
            registers[register, default: 0]
        }
        
        func getValue(for value: OpCodeValue) -> Int {
            value.value(with: registers)
        }
    }
    
    enum State {
        case none
        case running
        case waitingForInput
    }
    
    protocol ProgramDelegate: AnyObject {
        func receive(_ value: Int)
        func isQueueEmpty() -> Bool
    }
    
    final class Program: ProgramDelegate {
        let id: String
        let operations: [OpCode]
        private var index: Int = 0
        private var registers: Registers = [:]
        private var queue: [Int] = []
        private(set) var state: State = .none
        weak var delegate: ProgramDelegate?
        private(set) var sendCount = 0
        private var receiveCount = 0
        var key: String {
            [
                id,
                queue.isEmpty ? "n/a" : String(queue.first!),
                String(index),
                registers.sorted(by: { $0.key < $1.key }).map({ String($0.key) + ": " + String($0.value) }).joined(separator: ", ")
            ].joined(separator: " ")
        }

        init(id: String, operations: [OpCode], registers: Registers) {
            self.id = id
            self.operations = operations
            self.registers = registers
            self.state = .running
        }
        
        private func end() {
            state = .none
        }
        
        func tick() {
            guard state == .running else { return }
            guard index < operations.count else {
                end()
                return
            }
            
            var receivedRegister: Register?
            
            registers = operations[index].execute(on: registers) { value in
                // ignore
            } send: { value in
                sendCount += 1
                delegate?.receive(value)
            } recover: { _ in
                // ignore
            } receive: { register, _ in
                receiveCount += 1
                receivedRegister = register
            } jump: { value in
                index += value - 1
            }
            
            if let register = receivedRegister {
                if !queue.isEmpty {
                    let value = queue.removeFirst()
                    if value != 0 {
                        registers[register] = value
                    }
                } else {
                    state = .waitingForInput
                }
            }

            index += 1
        }
        
        func isQueueEmpty() -> Bool {
            queue.isEmpty
        }
        
        func receive(_ value: Int) {
            queue.append(value)
            if state != .none {
                state = .running
            }
        }
    }
    
    public typealias Registers = [Register: Value]
    public typealias Register = Character
    public typealias Value = Int
    
    public struct OpCodeValue {
        private let storage: String
        
        public init(_ input: String) {
            self.storage = input
        }
                
        public func value(with registers: Registers) -> Int {
            if let value = Int(storage) { return value }
            return registers[Character(storage), default: 0]
        }
    }
    
    public enum OpCode {
        public enum Version {
            case v1, v2
        }
        
        case play(OpCodeValue) // v1
        case send(OpCodeValue) // v2
        case recover(Register) // v1
        case receive(Register) // v2
        case set(Register, OpCodeValue)
        case add(Register, OpCodeValue)
        case multiply(Register, OpCodeValue)
        case mod(Register, OpCodeValue)
        case jump(Register, OpCodeValue)
        
        public init(_ value: String, version: Version) {
            let parts = value.split(separator: " ")
            switch parts[0] {
            case "snd":
                switch version {
                case .v1: self = .play(OpCodeValue(String(parts[1])))
                case .v2: self = .send(OpCodeValue(String(parts[1])))
                }
                
            case "rcv":
                switch version {
                case .v1: self = .recover(Register(parts[1]))
                case .v2: self = .receive(Register(parts[1]))
                }
            case "set": self = .set(Register(parts[1]), OpCodeValue(String(parts[2])))
            case "add": self = .add(Register(parts[1]), OpCodeValue(String(parts[2])))
            case "mul": self = .multiply(Register(parts[1]), OpCodeValue(String(parts[2])))
            case "mod": self = .mod(Register(parts[1]), OpCodeValue(String(parts[2])))
            case "jgz": self = .jump(Register(parts[1]), OpCodeValue(String(parts[2])))
            default: fatalError("Unknown opcode \(parts[0])")
            }
        }
        
        func execute(
            on registers: Registers,
            playSound: (Value) -> Void,
            send: (Value) -> Void,
            recover: (Value) -> Void,
            receive: (Register, Value) -> Void,
            jump: (Value) -> Void
        ) -> Registers {
            var registers = registers
            switch self {
            case let .play(value):
                playSound(getValue(for: value, registers: registers))
                
            case let .send(value):
                send(getValue(for: value, registers: registers))
                
            case let .recover(register):
                if registers[register, default: 0] != 0 {
                    recover(getValue(for: register, registers: registers))
                }
            case let .receive(register):
                if getValue(for: register, registers: registers) != 0 {
                    receive(register, getValue(for: register, registers: registers))
                }

            case let .set(register, value):
                registers[register] = getValue(for: value, registers: registers)
                
            case let .add(register, value):
                registers[register] = getValue(for: register, registers: registers) + getValue(for: value, registers: registers)
                
            case let .multiply(register, value):
                registers[register] = getValue(for: register, registers: registers) * getValue(for: value, registers: registers)
                
            case let .mod(register, value):
                registers[register] = getValue(for: register, registers: registers) % getValue(for: value, registers: registers)
                
            case let .jump(register, value):
                if getValue(for: register, registers: registers) > 0 {
                    jump(getValue(for: value, registers: registers))
                }
            }
            return registers
        }
        
        func getValue(for register: Register, registers: Registers) -> Int {
            registers[register, default: 0]
        }
        
        func getValue(for value: OpCodeValue, registers: Registers) -> Int {
            value.value(with: registers)
        }
    }
}

