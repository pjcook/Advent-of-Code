import Foundation
import StandardLibraries

public struct Day23 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let pairs = parse(input)
        var nodes = [String: Node]()
        
        for pair in pairs {
            let nodeA = nodes[pair.a, default: Node(id: pair.a, connections: [])]
            let nodeB = nodes[pair.b, default: Node(id: pair.b, connections: [])]
            nodeA.addNode(nodeB)
            nodeB.addNode(nodeA)
            nodes[pair.a] = nodeA
            nodes[pair.b] = nodeB
        }
        
        var parties = Set<[String]>()
        nodes.values.forEach {
            $0.parties.forEach { parties.insert($0) }
        }
                
        return parties.filter { $0.filter({ $0.hasPrefix("t") }).count > 0 }.count
    }
    
    public func part2(_ input: [String]) -> String {
        let pairs = parse(input)
        var nodes = [String: Node]()
        
        for pair in pairs {
            let nodeA = nodes[pair.a, default: Node(id: pair.a, connections: [])]
            let nodeB = nodes[pair.b, default: Node(id: pair.b, connections: [])]
            nodeA.addNode(nodeB)
            nodeB.addNode(nodeA)
            nodes[pair.a] = nodeA
            nodes[pair.b] = nodeB
        }
        
        var largest: [String] = []
        for node in nodes.values {
            var computers = Set<String>()
            for party in node.parties {
                party.forEach { computers.insert($0) }
            }
            
            let results = computers.filter {
                var c2 = computers
                c2.remove($0)
                return Set(nodes[$0]!.connectedIDs).isSuperset(of: c2)
            }
            
            if results.count > largest.count {
                largest = Array(results)
            }
        }
        
        return largest.sorted().joined(separator: ",")
    }
    
    final class Node: Hashable {
        static func == (lhs: Day23.Node, rhs: Day23.Node) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        let id: String
        var connections: Set<Node>
        
        init(id: String, connections: Set<Node>) {
            self.id = id
            self.connections = connections
        }
        
        func addNode(_ node: Node) {
            connections.insert(node)
        }
        
        var parties: [[String]] {
            var parties = Set<[String]>()
            
            outerLoop: for a in connectedIDs {
                for connection in connections where connection.id != a {
                    if connection.connectedIDs.contains(a) {
                        parties.insert([id, a, connection.id].sorted())
                    }
                }
            }
            
            return Array(parties)
        }
        
        var connectedIDs: [String] {
            connections.map({ $0.id })
        }
    }
}

extension Day23 {
    func parse(_ input: [String]) -> [Pair<String>] {
        var pairs = [Pair<String>]()
        
        for line in input {
            let components = line.split(separator: "-")
            let pair = Pair(String(components[0]), String(components[1]))
            pairs.append(pair)
        }
        
        return pairs
    }
}
