import Foundation
import StandardLibraries

public class Day13 {
    public init() {}
    public typealias Key = String   // name1 -> name2
    public typealias Day13Data = [Key:Int]
    public var happiestRoute: Node?
    
    public class Node: CustomDebugStringConvertible {
        let id: String
        var parent: Node?
        let cost: Int
        
        public init(id: String, parent: Node?, cost: Int) {
            self.id = id
            self.parent = parent
            self.cost = cost
        }
        
        public var debugDescription: String {
            var desc = "\(id): \(cost)"
            if let parent = parent {
                desc += " -> \(parent.debugDescription)"
            }
            return desc
        }
    }
    
    public let regex = try! RegularExpression(pattern: "^(\\w+) would ([lose|gain]+) (\\d+) happiness units by sitting next to (\\w+).$")
    
    public func part1(_ input: [String]) throws -> Int {
        let (keys, data) = try parse(input)
        for destination in keys {
            let node = Node(id: destination, parent: nil, cost: 0)
            var destinations = keys
            destinations.remove(destination)
            buildTree(node, destinations: destinations, data: data, startingNode: node)
        }
        return happiestRoute?.cost ?? -1
    }
    
    public func part2(_ input: [String]) throws -> Int {
        var (keys, data) = try parse(input)
        for key in keys {
            data[self.key(key, "santa")] = 0
            data[self.key("santa", key)] = 0
        }
        keys.insert("santa")
        for destination in keys {
            let node = Node(id: destination, parent: nil, cost: 0)
            var destinations = keys
            destinations.remove(destination)
            buildTree(node, destinations: destinations, data: data, startingNode: node)
        }
        return happiestRoute?.cost ?? -1
    }
    
    public func buildTree(_ node: Node, destinations: Set<Key>, data: Day13Data, startingNode: Node) {
        guard !destinations.isEmpty else {
            let cost1 = data[key(node.id, startingNode.id)]!
            let cost2 = data[key(startingNode.id, node.id)]!
            let n = Node(id: startingNode.id, parent: node, cost: node.cost + cost1 + cost2)
            if n.cost > happiestRoute?.cost ?? -1 {
                happiestRoute = n
            }
            return
        }
        
        for destination in destinations {
            let cost1 = data[key(node.id, destination)]!
            let cost2 = data[key(destination, node.id)]!
            let n = Node(id: destination, parent: node, cost: node.cost + cost1 + cost2)
            var d = destinations
            d.remove(destination)
            buildTree(n, destinations: d, data: data, startingNode: startingNode)
        }
    }
    
    public func parse(_ input: [String]) throws -> (Set<Key>, Day13Data) {
        var keys = Set<Key>()
        var data = Day13Data()
        
        for line in input {
            let match = try regex.match(line)
            let source = try match.string(at: 0)
            let likes = try match.string(at: 1)
            let amount = try match.integer(at: 2)
            let destination = try match.string(at: 3)
            
            keys.insert(source)
            keys.insert(destination)
            data[key(source, destination)] = likes == "gain" ? amount : -amount
        }
        
        return (keys, data)
    }
    
    public func key(_ source: String, _ destination: String) -> String {
        "\(source) -> \(destination)"
    }
}
