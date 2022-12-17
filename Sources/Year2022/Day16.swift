//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public class Day16 {
    public init() {}
    
    public func part1(_ input: String) -> Int {
        let chambers = parse(input)
        let start = chambers["AA"]!
        return explore(current: start, chambers: chambers, depth: 1, maxDepth: 30, pressure: 0, runningTotal: 0, history: [start.id])
    }
    
    public func part2(_ input: String) -> Int {
        return 1
    }
    
    var maxValue = 0
}

extension Day16 {
    public func explore(current: Chamber, chambers: [String: Chamber], depth: Int, maxDepth: Int, pressure: Int, runningTotal: Int, history: [String]) -> Int {
//        if runningTotal > maxValue {
//            maxValue = runningTotal
//        }
//        print("explore:", depth, maxValue, current.id, pressure, runningTotal, history.joined(separator: ","))
//        guard depth < maxDepth else { return pressure }
//        let queue = PriorityQueue<Chamber>()
//
//        for id in current.tunnels {
//            let chamber = chambers[id]!
//            let priority = pressure + history.filter({ $0 == chamber.id }).count
//
//            // TODO: look forward to find best path forward not zero and not already open
////            guard !history.suffix(min(chamber.tunnels.count, maxDepth - depth)).contains(chamber.id) else { continue }
//            if chamber.flowRate == 0 {
//                queue.enqueue(chamber, priority: priority)
//            } else if chamber.valveOpen {
//                queue.enqueue(chamber, priority: priority)
//            } else {
////                queue.enqueue(chamber, priority: pressure)
//                queue.enqueue(chamber.toggleWillOpen(), priority: priority - chamber.flowRate)
//            }
//        }
//
//        if queue.isEmpty {
//            print("explore:", depth, current.id, pressure, runningTotal, history.joined(separator: ","))
//            return runningTotal + ((maxDepth - depth) * pressure)
//        }
//
//        var currentMaxTotal = runningTotal
//
//        while !queue.isEmpty {
//            var chamber = queue.dequeue()!
//            var chambers = chambers
//            var depth = depth
//            var pressure = pressure
//            var runningTotal = runningTotal
//            chamber = chamber.visiting(from: current.id)
//            if chamber.willOpen {
//                chamber = chamber.toggleWillOpen()
//                chamber = chamber.openValue()
//                chambers[chamber.id] = chamber
//                if depth + 2 <= maxDepth {
//                    depth += 2
//                    runningTotal += pressure * 2
//                    pressure += chamber.flowRate
//                } else {
//                    depth += 1
//                    runningTotal += pressure
//                }
//            } else {
//                depth += 1
//                runningTotal += pressure
//            }
//
//            let result = explore(current: chamber, chambers: chambers, depth: depth, maxDepth: maxDepth, pressure: pressure, runningTotal: runningTotal, history: history + [chamber.id])
//            if result > currentMaxTotal {
//                currentMaxTotal = result
//            }
//        }
        
//        return currentMaxTotal
        return 1
    }
}

extension Day16 {
    public struct Destination: Hashable {
        public let id: String
        public let distance: Int
    }
    
    public struct Node: Hashable {
        public let id: String
        public let flowRate: Int
        public let destinations: [Destination]
        public let valveOpen: Bool
    }
    
    public struct Chamber: Hashable, CustomDebugStringConvertible {
        public let id: String
        public let flowRate: Int
        public let tunnels: [String]
        public let valveOpen: Bool
        
        public init(id: String, tunnels: [String], flowRate: Int, valveOpen: Bool = false) {
            self.id = id
            self.tunnels = tunnels
            self.flowRate = flowRate
            self.valveOpen = valveOpen
        }
        
        public func openValue() -> Chamber {
            Chamber(id: id, tunnels: tunnels, flowRate: flowRate, valveOpen: true)
        }
        
        public var debugDescription: String {
            "\(id); \(flowRate); \(tunnels.joined(separator: ","));"
        }
    }
    
    public func compressGraph(chambers: [String: Chamber]) -> [String: Node] {
        var results = [String: Node]()
        let valveChambers = chambers.filter({ $0.value.flowRate > 0 || $0.value.id == "AA" })

        for valveChamber in valveChambers {
            var destinations = [Destination]()
            var distance = 1
            for chamberId in valveChamber.value.tunnels {
                var nextId = chamberId
                var prevId = valveChamber.key
                while true {
                    let node = chambers[nextId]!
                    if node.flowRate == 0 {
                        distance += 1
                        let id = node.tunnels.first(where: { $0 != prevId })!
                        prevId = nextId
                        nextId = id
                    } else {
                        destinations.append(Destination(id: node.id, distance: distance))
                        break
                    }
                }
            }
            results[valveChamber.value.id] = Node(id: valveChamber.value.id, flowRate: valveChamber.value.flowRate, destinations: destinations, valveOpen: false)
        }
        
        return results
    }
    
    public func parse(_ input: String) -> [String: Chamber] {
        var output = [String: Chamber]()
        let lines = input
            .replacingOccurrences(of: "Valve ", with: "")
            .replacingOccurrences(of: " has flow rate=", with: "|")
            .replacingOccurrences(of: "; tunnel leads to valve ", with: "|")
            .replacingOccurrences(of: "; tunnels lead to valves ", with: "|")
            .components(separatedBy: "\n")
        
        for line in lines {
            let parts = line.components(separatedBy: "|")
            let destinations = parts[2].components(separatedBy: ", ")
            output[parts[0]] = Chamber(id: parts[0], tunnels: destinations, flowRate: Int(parts[1])!)
        }
        
        return output
    }
}
