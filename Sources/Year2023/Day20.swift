import Foundation
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: [String], count: Int) -> Int {
        var modules = parse(input)
        var lowCount = 0
        var highCount = 0
//        modules.forEach { print($0.value) }
                
        for _ in (0..<count) {
            let (_, l, h) = sendSignal(modules: &modules, input: .low)
            lowCount += l
            highCount += h
        }
        
        return lowCount * highCount
    }
    
    public func part2(_ input: [String]) -> Int {
        var modules = parse(input)
        var count = 0
        
//        modules.forEach { print($0.value) }
//        print()
        var flipFlop = [String: Int]()
        for module in modules.values where module.moduleType == .conjunction {
            print(module.id)
        }
        print()

        while true {
            count += 1
            _ = sendSignal(modules: &modules, input: .low)
//            modules.forEach { print($0.value) }
//            print()
            
            for module in modules.values where module.moduleType == .conjunction {
                let value = flipFlop[module.id, default: 0]
                if value == 0 && module.conjunctionState.reduce(true, { $0 && $1.value == .high }) {
                    flipFlop[module.id] = count
                }
            }
            
            let module = modules["dh"]!
            if module.conjunctionState.reduce(true, { $0 && $1.value == .high }) {
                break
            }
            if count % 10_000 == 0 {
                print(count)
                flipFlop.forEach {
                    print($0.key, $0.value)
                }
                print()
            }
        }
        return count
    }
    
    func calculate() {
        var tb = true // vc, th
        var dv = true // jx, sm
        var qg = true // sj, hd
        var lf = true // tn, xv
        
        var vc = ["tb": Pulse.low, "nb": Pulse.low, "lg": Pulse.low, "gv": Pulse.low, "nc": Pulse.low, "mc": Pulse.low, "hb": Pulse.low, "tz": Pulse.low] // tb, mf, dr, th, kk, bk
        var jx = ["dv": Pulse.low, "dx": Pulse.low, "bv": Pulse.low, "vs": Pulse.low, "bt": Pulse.low, "ml": Pulse.low, "qb": Pulse.low] // sm, jv, xc, qm, dv, nh, kf
        var hd = ["qg": Pulse.low, "sj": Pulse.low, "lj": Pulse.low, "sg": Pulse.low, "bh": Pulse.low, "sc": Pulse.low, "cp": Pulse.low, "ps": Pulse.low] // bs, gk, tr, qg, ln, cx
        var tn = ["lf": Pulse.low, "tt": Pulse.low, "pd": Pulse.low, "lp": Pulse.low, "gp": Pulse.low, "nv": Pulse.low, "bm": Pulse.low] // lf, xv, xm, nn, mz, fc, ng
        var th = false // gv
        var sm = false // jv
        var sj = false // ln, hd
        var xv = false // mz
        
        var mf = false // lg
        // [vc]
        var dr = [Pulse.low] // dh
        var kk = false // nb
        var bk = false // nc
        var gv = false // vc, bk
        var jv = false // xc
        var xc = false // dx
        var qm = false // kf
        // [jx]
        var nh = [Pulse.low] // dh
        var kf = false // bv
        var ln = false // ps
        var bs = false // lj
        var gk = false // bs
        // [hd]
        var tr = [Pulse.low] // dh
        var cx = false // bh
        // [tn]
        var xm = [Pulse.low] // dh
        var nn = false // nv
        var mz = false // fc
        var fc = false // tt
        var ng = false // gp
        
        var lg = false // tz, vc
        var dh = ["dr": Pulse.low, "nh": Pulse.low, "tr": Pulse.low, "xm": Pulse.low] // rx
        var nb = false // vc, hb
        var nc = false // kk, vc
        var dx = false // jx, vs
        var bh = false // hd, cp
        var nv = false // pd, tn
        var tt = false // lp, tn
        var gp = false // tn, nn
        
        var tz = false // vc, mc
        var hb = false // vc, mf
        var vs = false // qm, jx
        var cp = false // sc, hd
        var pd = false // tn, bm
        var lp = false // tn, ng
        
        var mc = false // vc
        var sc = false // hd
        var bm = false // tn
        
        var lj = false // hd, cx
        var bv = false // ml, jx
        var sg = false // gk, hd
        var bt = false // jx
        var ps = false // hd, sg
        var ml = false // qb, jx
        var qb = false // bt, jx
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
