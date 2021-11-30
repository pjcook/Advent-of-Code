import Foundation
import StandardLibraries

public class Day9 {
    public init() {}
    public typealias Key = String   // "Source->Destination"
    public typealias Day9Data = (Set<String>, [Key:Int])
    public var shortestRoute: Node?
    public var longestRoute: Node?
    
    static let regex = try! RegularExpression(pattern: "^(\\w+) to (\\w+) = (\\d+)$")
    public class Node: CustomDebugStringConvertible {
        let id: String
        var parent: Node?
        let cost: Int
        var children: [Node]?
        
        public init(id: String, parent: Node?, cost: Int, children: [Node]?) {
            self.id = id
            self.parent = parent
            self.cost = cost
            self.children = children
        }
        
        public var debugDescription: String {
            var desc = "\(id): \(cost)"
            if let parent = parent {
                desc += " -> \(parent.debugDescription)"
            }
            return desc
        }
    }
    
    public func part1(_ input: [String]) throws -> Int {
        let (destinations, data) = try parse(input)
        var nodes = [Node]()
        for item in destinations {
            let node = Node(id: item, parent: nil, cost: 0, children: nil)
            var d = destinations
            d.remove(item)
            nodes.append(buildTree(node, destinations: d, data: data))
        }
        return shortestRoute?.cost ?? -1
    }
    
    public func part2(_ input: [String]) throws -> Int {
        let (destinations, data) = try parse(input)
        var nodes = [Node]()
        for item in destinations {
            let node = Node(id: item, parent: nil, cost: 0, children: nil)
            var d = destinations
            d.remove(item)
            nodes.append(buildTree(node, destinations: d, data: data))
        }
        return longestRoute?.cost ?? -1
    }
    
    public func buildTree(_ node: Node, destinations: Set<String>, data: [Key:Int]) -> Node {
        guard !destinations.isEmpty else {
            if node.cost < shortestRoute?.cost ?? Int.max {
                shortestRoute = node
            }
            
            if node.cost > longestRoute?.cost ?? 0 {
                longestRoute = node
            }
            return node
        }
        
        var children = [Node]()
        
        for destination in destinations {
            let n = Node(id: destination, parent: node, cost: data[key(node.id, destination)]! + node.cost, children: nil)
            var d = destinations
            d.remove(destination)
            children.append(buildTree(n, destinations: d, data: data))
        }
        
        node.children = children
        return node
    }
    
    public func parse(_ input: [String]) throws -> Day9Data {
        var destinations = Set<String>()
        var data = [Key:Int]()
        
        for line in input {
            let match = try Self.regex.match(line)
            let source = try match.string(at: 0)
            let destination = try match.string(at: 1)
            let distance = try match.integer(at: 2)
            
            destinations.insert(source)
            destinations.insert(destination)
            data[key(source, destination)] = distance
            data[key(destination, source)] = distance
        }
        
        return (destinations, data)
    }
    
    public func key(_ source: String, _ destination: String) -> String {
        "\(source) -> \(destination)"
    }
}
