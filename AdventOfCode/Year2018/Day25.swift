import Foundation

public struct Day25 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let nodes = parse(input)
        
        for node in nodes {
            for n in nodes {
                guard node != n else { continue }
                if node.manhattan(n) <= 3 {
                    node.children.insert(n)
                    n.parents.insert(node)
                }
            }
        }
        
        var constellations = Set<Set<Node>>()
        for node in nodes {
            var tree = node.familyTree([])
            if tree.isEmpty {
                tree = [node]
            }
            constellations.insert(tree)
        }
        
        return constellations.count
    }
    
    public func parse(_ input: [String]) -> [Node] {
        return input.map(Node.init)
    }
}

extension Day25 {
    public class Node: Hashable {
        public let quad: Quad
        public var children: Set<Node> = []
        public var parents: Set<Node> = []
        
        public init(_ input: String) {
            self.quad = Quad(input)
        }
        
        public static func == (lhs: Node, rhs: Node) -> Bool {
            return lhs.quad == rhs.quad
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(quad)
        }
        
        public func manhattan(_ node: Node) -> Int {
            return quad.manhattan(node.quad)
        }
        
        public func familyTree(_ nodes: Set<Node>) -> Set<Node> {
            var nodes = nodes
            var new = Set<Node>()
            
            for node in parents {
                if !nodes.contains(node) {
                    new.insert(node)
                }
            }
            
            for node in children {
                if !nodes.contains(node) {
                    new.insert(node)
                }
            }
            
            for node in new {
                nodes.insert(node)
            }
            
            for node in new {
                nodes = node.familyTree(nodes)
            }
            
            return nodes
        }
    }

    public struct Quad: Hashable {
        public let w: Int
        public let x: Int
        public let y: Int
        public let z: Int
        
        public init(_ input: String) {
            let values = input.components(separatedBy: ",")
            w = Int(values[0])!
            x = Int(values[1])!
            y = Int(values[2])!
            z = Int(values[3])!
        }
        
        public func manhattan(_ quad: Quad) -> Int {
            return abs(w - quad.w) + abs(x - quad.x) + abs(y - quad.y) + abs(z - quad.z)
        }
    }
}

extension Day25.Node: CustomStringConvertible {
    public var description: String {
        return quad.description
    }
}

extension Day25.Quad: CustomStringConvertible {
    public var description: String {
        return "[\(w), \(x), \(y), \(z)]"
    }
}
