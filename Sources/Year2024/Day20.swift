import Foundation
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var modules = parse(input)
        var lowCount = 0
        var highCount = 0
//        modules.forEach { print($0.value) }
                
        for _ in (0..<1000) {
            let (_, l, h) = sendSignal(modules: &modules, input: .low)
            lowCount += l
            highCount += h
        }
        
        return lowCount * highCount
    }
    
    public func part2(_ input: [String]) -> Int {
        1
    }
    
    func sendSignal(modules: inout [String: Module], input: Pulse) -> (Pulse, Int, Int) {
        var queue = [("broadcaster", input)]
        var lowCount = input == .low ? 1 : 0
        var highCount = input == .high ? 1 : 0

        func sendSignal(signal: Pulse, to: [String], from: String) {
            for id in to {
                if signal == .high {
                    highCount += 1
                } else {
                    lowCount += 1
                }
                guard var module = modules[id] else { continue }
                if module.moduleType == .conjunction {
                    module.conjunctionState[from] = signal
                    modules[id] = module
                }
//                print(id, signal)
                queue.append((id, signal))
            }
        }
                
        // process queue
        var lastPulse = input
        while !queue.isEmpty {
            let (moduleID, pulse) = queue.removeFirst()
            lastPulse = pulse
            guard var module = modules[moduleID] else {
                return (lastPulse, lowCount, highCount)
            }

            /*
             % flipFlop module either on/off initially off.
             if receive highPulse ignore, lowPulse toggle state.
             If it was off, send a highPulse.
             If it was on, send a lowPulse.
             
             & conjunction module.
             Remember the type of most recent pulse of each input, initially all lowPulse.
             If all inputs are highPulse, send a lowPulse, otherwise send a highPulse.
             
             broadcaster module.
             repeat input pulse to all destination modules.

            */
            
            switch module.moduleType {
                case .flipFlop:
                    let originalState = module.flipFlopState
                    if pulse == .low {
                        module.flipFlopState = !module.flipFlopState
                        modules[module.id] = module
                        sendSignal(signal: originalState == false ? .high : .low, to: module.output, from: moduleID)
                    }                    

                case .conjunction:
                    if module.conjunctionState.values.reduce(true, { $0 && $1 == .high }) {
                        sendSignal(signal: .low, to: module.output, from: moduleID)
                    } else {
                        sendSignal(signal: .high, to: module.output, from: moduleID)
                    }

                case .broadcaster:
                    sendSignal(signal: pulse, to: module.output, from: moduleID)
            }
        }
        
        return (lastPulse, lowCount, highCount)
    }
    
    enum ModuleType: String, CustomStringConvertible {
        case flipFlop = "%"
        case conjunction = "&"
        case broadcaster = "B"
        
        var description: String { rawValue }
    }
    
    struct Module: CustomStringConvertible {
        let id: String
        let moduleType: ModuleType
        let output: [String]
        let connectedInputs: [String]
        var flipFlopState = false
        var conjunctionState: [String: Pulse]
        
        var description: String {
            "\(id):\(moduleType) -> \(output.joined(separator: ",")); \(connectedInputs); FF(\(flipFlopState ? "1" : "0");\(conjunctionState)"
        }
    }
    
    enum Pulse: String, CustomStringConvertible {
        case high, low
        
        var description: String { rawValue }
    }
}

extension Day20 {
    func parse(_ input: [String]) -> [String: Module] {
        var results = [String: Module]()
        
        // %sg -> gk, hd
        for line in input {
            var components = line
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "->", with: ",")
                .components(separatedBy: ",")
            
            let moduleType = components[0] == "broadcaster" ? .broadcaster : ModuleType(rawValue: String(components[0].removeFirst()))!
            let id = components[0]
            let output = Array(components[1...])
            let module = Module(id: id, moduleType: moduleType, output: output, connectedInputs: [], conjunctionState: [:])
            results[id] = module
        }
        
        // connect state for conjunction
        let connectors = results.values.filter {
            $0.moduleType == .conjunction
        }
        
        for connector in connectors {
            let connectedInputs = results.values
                .filter {
                    $0.output.contains(connector.id)
                }
                .map { $0.id }
            var state = [String: Pulse]()
            for id in connectedInputs {
                state[id] = .low
            }
            results[connector.id] = Module(id: connector.id, moduleType: connector.moduleType, output: connector.output, connectedInputs: connectedInputs, conjunctionState: state)
        }
        
        return results
    }
}
