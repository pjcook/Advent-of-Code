import Foundation
import StandardLibraries

public struct Day8 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        var results = Set<Point>()
        var antenna = [String: [Node]]()
        
        for i in (0..<grid.items.count) {
            let char = grid.items[i]
            guard char != "." else { continue }
            
            let point = grid.point(for: i)
            var nodes = antenna[char, default: []]
            nodes.append(Node(point: point, char: char))
            antenna[char] = nodes
        }

        for (_, items) in antenna where items.count > 1 {
            for n in (0..<items.count-1) {
                for j in (n..<items.count-1) {
                    let p1 = items[n].point
                    let p2 = items[j+1].point
                    let d2 = p1 - p2
                    let point1 = p1 + d2
                    let point2 = p2 - d2
                    if point1.isValid(max: grid.bottomRight) {
                        results.insert(point1)
                    }
                    if point2.isValid(max: grid.bottomRight) {
                        results.insert(point2)
                    }
                }
            }
        }
        
        return results.count
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        var results = Set<Point>()
        var antenna = [String: [Node]]()
        
        for i in (0..<grid.items.count) {
            let char = grid.items[i]
            guard char != "." else { continue }
            
            let point = grid.point(for: i)
            var nodes = antenna[char, default: []]
            nodes.append(Node(point: point, char: char))
            antenna[char] = nodes
        }

        for (_, items) in antenna where items.count > 1 {
            for n in (0..<items.count-1) {
                for j in (n..<items.count-1) {
                    let p1 = items[n].point
                    let p2 = items[j+1].point
                    results.insert(p1)
                    results.insert(p2)
                    let d2 = p1 - p2
                    var point1 = p1 + d2
                    var point2 = p2 - d2
                    while point1.isValid(max: grid.bottomRight) {
                        results.insert(point1)
                        point1 = point1 + d2
                    }
                    while point2.isValid(max: grid.bottomRight) {
                        results.insert(point2)
                        point2 = point2 - d2
                    }
                }
            }
        }
        
        return results.count
    }
    
    public struct Node: Hashable {
        public let point: Point
        public let char: String
    }
}
