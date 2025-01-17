//
//  Created by PJ on 16/01/2025.
//

public protocol ComputerDelegate: AnyObject {
    func readInput(id: Int) -> Int
    func computerFinished(id: Int)
    func processOutput(id: Int, value: Int)
}

public final class Computer {
    public typealias Registers = [Int: Int]
    
    enum OpCode: Int {
        case add = 1
        case multiply = 2
        case input = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case adjustRelativeBase = 9
        case finished = 99
        
        func incrementPosition(_ instructionIndex: Int) -> Int {
            switch self {
            case .jumpIfTrue, .jumpIfFalse: return instructionIndex
            case .add, .multiply, .lessThan, .equals: return instructionIndex + 4
            case .input, .output, .adjustRelativeBase: return instructionIndex + 2
            case .finished: return instructionIndex
            }
        }
        
        
    }
    
    enum Mode: Int {
        case position = 0
        case immediate = 1
        case relative = 2
        
        func writePosition(registers: Registers, index: Int, relativeBase: Int) -> Int {
            switch self {
            case .immediate: index
            case .position: registers[index, default: 0]
            case .relative: relativeBase + registers[index, default: 0]
            }
        }
        
        func read(registers: Registers, index: Int, relativeBase: Int) -> Int {
            switch self {
            case .immediate: registers[index, default: 0]
            case .position: registers[registers[index, default: 0], default: 0]
            case .relative: registers[relativeBase + registers[index, default: 0], default: 0]
            }
        }
    }
    
    public enum State {
        case running, waiting, finished
    }
    
    public let id: Int
    private let forceWriteMode: Bool
    private var registers = Registers()
    private var pointer = 0
    private var relativeBase = 0
    private var currentValue: Int? {
        registers[pointer]
    }
    public private(set) var state: State = .running
    public private(set) var output: Int?
    public var isFinished: Bool { state == .finished }
    public weak var delegate: ComputerDelegate?
    
    public init(id: Int = 0, forceWriteMode: Bool) {
        self.id = id
        self.forceWriteMode = forceWriteMode
    }
    
    public func registerValue(for index: Int) -> Int? {
        registers[index]
    }
    
    public func loadProgram(_ input: [Int]) {
        for i in 0..<input.count {
            registers[i] = input[i]
        }
    }
    
    public func stop() {
        state = .finished
        delegate?.computerFinished(id: id)
    }
    
    public func reset() {
        pointer = 0
        state = .running
    }
    
    public func tick() {
        guard state != .finished else { return }
        guard let instruction = currentValue,
              let opCode = OpCode(rawValue: instruction % 100),
              let mode1 = Mode(rawValue: instruction % 10000 % 1000 / 100),
              let mode2 = Mode(rawValue: instruction % 10000 / 1000),
              let mode3 = Mode(rawValue: instruction / 10000)
        else {
            state = .finished
            return
        }
        let writeMode = forceWriteMode ? .position : mode3
        switch opCode {
        case .add:
            let values = readValues(modes: [mode1, mode2, writeMode])
            writeData(values[2], values[0] + values[1])
            
        case .multiply:
            let values = readValues(modes: [mode1, mode2, writeMode])
            writeData(values[2], values[0] * values[1])
            
        case .input:
            let writeIndex = mode1.writePosition(registers: registers, index: pointer + 1, relativeBase: relativeBase)
            if let input = readInput(), input != -1 {
                writeData(writeIndex, input)
            }
            
        case .output:
            writeOutput(readValues(modes: [mode1])[0])
            
        case .jumpIfTrue:
            let values = readValues(modes: [mode1, mode2])
            pointer = values[0] != 0 ? values[1] : pointer + 3

        case .jumpIfFalse:
            let values = readValues(modes: [mode1, mode2])
            pointer = values[0] == 0 ? values[1] : pointer + 3
            
        case .lessThan:
            let values = readValues(modes: [mode1, mode2, writeMode])
            writeData(values[2], values[0] < values[1] ? 1 : 0)
            
        case .equals:
            let values = readValues(modes: [mode1, mode2, writeMode])
            writeData(values[2], values[0] == values[1] ? 1 : 0)
            
        case .adjustRelativeBase:
            let value = mode1.read(registers: registers, index: pointer + 1, relativeBase: relativeBase)
            relativeBase += value
            
        case .finished:
            stop()
        }
        
        pointer = opCode.incrementPosition(pointer)
    }
    
    private func readInput() -> Int? {
        delegate?.readInput(id: id)
    }
    
    private func writeData(_ index: Int, _ value: Int) {
        registers[index] = value
    }
    
    private func writeOutput(_ value: Int) {
//        print("output", id, value)
        output = value
        delegate?.processOutput(id: id, value: value)
    }
    
    private func readValues(modes: [Mode]) -> [Int] {
        switch modes.count {
        case 1: [modes[0].read(registers: registers, index: pointer + 1, relativeBase: relativeBase)]
        case 2: [
            modes[0].read(registers: registers, index: pointer + 1, relativeBase: relativeBase),
            modes[1].read(registers: registers, index: pointer + 2, relativeBase: relativeBase)
        ]
        case 3: [
            modes[0].read(registers: registers, index: pointer + 1, relativeBase: relativeBase),
            modes[1].read(registers: registers, index: pointer + 2, relativeBase: relativeBase),
            modes[2].writePosition(registers: registers, index: pointer + 3, relativeBase: relativeBase)
        ]
        default: fatalError("Invalid number of modes: \(modes.count)")
        }
    }
}
