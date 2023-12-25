import Foundation
import StandardLibraries

public struct Day25 {
    public init() {}
    // Code credit goes to: https://www.reddit.com/user/noonan1487/
    // https://www.reddit.com/user/noonan1487/
    struct Edge: Hashable, CustomStringConvertible {
        let a: String
        let b: String
        
        static func == (lhs: Edge, rhs: Edge) -> Bool {
            (lhs.a == rhs.a && lhs.b == rhs.b) || (lhs.a == rhs.b && lhs.b == rhs.a)
        }
        
        var description: String {
            "(\(a):\(b))"
        }
    }
    
    public func part1(_ input: [String]) -> Int {
        let (vertices, edges) = parse(input)
        
        var subsets = [[String]]()
        
        repeat {
            subsets = vertices.map { [$0] }
            var indices = (0..<edges.count).map { $0 }
            
            while subsets.count > 2 {
                let i = indices.randomElement()!
                indices.removeAll(where: { $0 == i })
                let edge = edges[i]
                guard var s1 = subsets.first(where: { $0.contains(edge.a) }) else { continue }
                guard let s2 = subsets.first(where: { $0.contains(edge.b) }) else { continue }
                if s1 == s2 { continue }
                let index = subsets.firstIndex(of: s1)!
                s1.append(contentsOf: s2)
                subsets[index] = s1
                subsets.remove(at: subsets.firstIndex(of: s2)!)
            }
        } while countCuts(subsets: subsets, edges: edges) != 3
        
        return subsets.reduce(1) { $0 * $1.count }
    }
    
    func countCuts(subsets: [[String]], edges: [Edge]) -> Int {
        var cuts = 0
        
        for edge in edges {
            let s1 = subsets.first { $0.contains(edge.a) }
            let s2 = subsets.first { $0.contains(edge.b) }
            if s1 != s2 { cuts += 1 }
        }
        
        return cuts
    }
}

extension Day25 {
    func parse(_ input: [String]) -> ([String], [Edge]) {
        var vertices = Set<String>()
        var edges = Set<Edge>()

        for line in input {
            let components = line.replacingOccurrences(of: ": ", with: " ")
                .components(separatedBy: " ")

            let p1 = components[0]
            vertices.insert(p1)

            for p2 in Array(components[1...]) {
                vertices.insert(p2)
                edges.insert(Edge(a: p1, b: p2))
            }
        }
        
        return (Array(vertices), Array(edges))
    }
}
