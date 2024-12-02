import Foundation
import StandardLibraries

public struct Day20b {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let (modules, broadcastTargets) = parse(input)
        
        var lowCount = 0
        var highCount = 0
        
        for _ in (0..<1000) {
            lowCount += 1
            // (origin, target, pulse)
            var queue = [(String, String, Pulse)]()
            broadcastTargets.forEach { queue.append(("broadcast", $0, .low)) }
            
            while !queue.isEmpty {
                let (origin, id, pulse) = queue.removeFirst()
                if pulse == .low {
                    lowCount += 1
                } else {
                    highCount += 1
                }
                
                guard let module = modules[id] else { continue }
                
                switch module.type {
                case .flipFlop:
                    if pulse == .low {
                        let value = module.storage.value as! Bool
                        module.storage = .flipFlip(!value)
                        let output = value == false ? Pulse.high : Pulse.low
                        for key in module.outputs {
                            queue.append((id, key, output))
                        }
                     }
                    
                case .conjunction:
                    var values = module.storage.value as! [String: Pulse]
                    values[origin] = pulse
                    module.storage = .conjunction(values)
                    let isHigh = values.values.reduce(true) { $0 && $1 == .high }
                    let output = isHigh ? Pulse.low : Pulse.high
                    for key in module.outputs {
                        queue.append((id, key, output))
                    }
                }
            }
        }
        
        return lowCount * highCount
    }
    
    public func part2(_ input: [String]) -> Int {
        let (modules, broadcastTargets) = parse(input)
        let feed = modules.values.first { $0.outputs.contains("rx") }!.name
        var cycleLengths = [String: Int]()
        var seen = modules.values
            .filter({ $0.outputs.contains(feed) })
            .map({ $0.name })
            .reduce(into: [String: Int]()) {
                $0[$1] = 0
            }
        
        var presses = 0
        while true {
            presses += 1
            // (origin, target, pulse)
            var queue = [(String, String, Pulse)]()
            broadcastTargets.forEach { queue.append(("broadcast", $0, .low)) }
            
            while !queue.isEmpty {
                let (origin, id, pulse) = queue.removeFirst()
                guard let module = modules[id] else { continue }
                
                if module.name == feed && pulse == .high {
                    seen[origin] = seen[origin, default: 0] + 1
                    if cycleLengths[origin] == nil {
                        cycleLengths[origin] = presses
                    } else {
                        assert(presses == seen[origin]! * cycleLengths[origin]!)
                    }

                    if seen.values.reduce(true, { $0 && $1 > 0 }) {
                        print(cycleLengths)
                        var x = 1
                        for cl in cycleLengths.values {
                            x = lowestCommonMultiple(x, cl)
                        }
                        return x
                    }
                }
                
                switch module.type {
                case .flipFlop:
                    if pulse == .low {
                        let value = module.storage.value as! Bool
                        module.storage = .flipFlip(!value)
                        let output = value == false ? Pulse.high : Pulse.low
                        for key in module.outputs {
                            queue.append((id, key, output))
                        }
                     }
                    
                case .conjunction:
                    var values = module.storage.value as! [String: Pulse]
                    values[origin] = pulse
                    module.storage = .conjunction(values)
                    let isHigh = values.values.reduce(true) { $0 && $1 == .high }
                    let output = isHigh ? Pulse.low : Pulse.high
                    for key in module.outputs {
                        queue.append((id, key, output))
                    }
                }
            }
        }
    }
    
    class Module: CustomStringConvertible {
        let name: String
        let type: ModuleType
        let outputs: [String]
        
        var storage: ModuleStorage
        
        init(name: String, type: ModuleType, outputs: [String]) {
            self.name = name
            self.type = type
            self.outputs = outputs
            if type == .flipFlop {
                storage = .flipFlip(false)
            } else {
                storage = .conjunction([:])
            }
        }
        
        var description: String {
            "\(name):\(type.rawValue) -> [\(outputs.joined(separator: ","))] \(storage)"
        }
    }
    
    enum ModuleStorage: CustomStringConvertible {
        case flipFlip(Bool)
        case conjunction([String: Pulse])
        
        var description: String {
            switch self {
            case let .flipFlip(value): value ? "on" : "off"
            case let .conjunction(values): "[" + values
                    .map {
                        "\($0.key):\($0.value)"
                    }
                    .joined(separator: ",")
                + "]"
            }
        }
        
        var value: Any {
            switch self {
            case let .flipFlip(value): return value
            case let .conjunction(values): return values
            }
        }
    }
    
    enum ModuleType: Character {
        case flipFlop = "%"
        case conjunction = "&"
    }
    
    enum Pulse {
        case low, high
    }
}

extension Day20b {
    func parse(_ input: [String]) -> ([String: Module], [String]) {
        var modules = [String: Module]()
        var broadcastTargets: [String] = []
        
        for line in input {
            let components = line
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "->", with: ",")
                .components(separatedBy: ",")
            
            if components[0] == "broadcaster" {
                broadcastTargets = Array(components[1...])
            } else {
                var name = String(components[0])
                let type = ModuleType(rawValue: name.removeFirst())!
                let module = Module(name: name, type: type, outputs: Array(components[1...]))
                modules[module.name] = module
            }
        }
        
        for module in modules.values where module.type == .conjunction {
            var storage = [String: Pulse]()
            modules.values
                .filter { $0.outputs.contains(module.name) }
                .map { $0.name }
                .forEach { storage[$0] = .low }
            module.storage = .conjunction(storage)
        }
        
        return (modules, broadcastTargets)
    }
}
