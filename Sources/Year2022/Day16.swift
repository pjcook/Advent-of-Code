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
        let nodes = compressGraph(chambers: chambers)
        let maxTime = 30
        var maxValue = 0
        var maxHistory = [String]()
        var queue = [(String, [String], Int, Int, Int)]()
        queue.append(("AA", [], 0, 0, 0))
        
        while !queue.isEmpty {
            let (id, history, time, total, value) = queue.removeFirst()
            let node = nodes[id]!
            var newTotal = total
            var newTime = time
            
            guard time < maxTime else { continue }

            var newValue = value
            
            // If not already open then open
            if !history.contains(id), node.flowRate > 0 {
                newTotal += value
                newTime += 1
                newValue += node.flowRate
            }
            
            var destinations = node.destinations.filter({ !history.suffix(1).contains($0.id) })
            if destinations.isEmpty {
                destinations = node.destinations
            }
            
            for next in destinations {
                if newTime + next.distance >= maxTime {
                    newTotal = newTotal + (newValue * (maxTime - newTime))
                    maxValue = max(maxValue, newTotal)
                    maxHistory = history
                    print(maxValue, newTime, newValue, history)
                } else {
                    var newHistory = history
                    newHistory.append(id)
                    let newTotal = newTotal + (newValue * next.distance)
                    queue.append((next.id, newHistory, newTime + next.distance, newTotal, newValue))
                    print(maxValue, newTime, newHistory)
                }
            }
        }
        print(maxValue, maxHistory)
        return maxValue
    }
    
    public func part2(_ input: String) -> Int {
        return 1
    }
    
    var maxValue = 0
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
                    if node.id != "AA", node.flowRate == 0 {
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
