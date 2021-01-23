import Foundation
import StandardLibraries

private var target: Point = .zero
private var depth: Int = 0
private var erosionLevels = [Point:Int]()

public class Day22 {
    public init() {}
        
    public func part1(depth d: Int, target t: Point) -> Int {
        if depth != d || target != t {
            depth = d
            target = t
            erosionLevels = [:]
        }
        let cave = Cave()
        return cave.riskLevel(at: target)
    }
    
    public func part2(depth d: Int, target t: Point) -> Int {
        if depth != d || target != t {
            depth = d
            target = t
            erosionLevels = [:]
        }
        let cave = Cave()
        return cave.cheapestPath(to: target)!.cost
    }
}

func draw() {
    for y in (0...target.y) {
        var line = ""
        for x in (0...target.x) {
            let point = Point(x,y)
            switch erosionLevels[point, default: 0] % 3 {
            case 0: line += "."
            case 1: line += "="
            default: line += "|"
            }
        }
        print(line)
    }
    print()
}

private class Cave {
    func riskLevel(at: Point) -> Int {
        return (0...at.y).flatMap { y in
            (0...at.x).map { x in
                Point(x,y).erosionLevel() % 3
            }
        }.reduce(0, +)
    }
    
    func cheapestPath(to: Point) -> Traversal? {
        var seen = [Key(point: .zero, tool: .torch):0]
        var pathsToEvaluate = [Traversal(end: .zero, holding: .torch, cost: 0)]
        
        while !pathsToEvaluate.isEmpty {
            pathsToEvaluate.sort(by: { $0.cost < $1.cost })
            let path = pathsToEvaluate.removeFirst()
            
            // Found it, and holding the correct tool
            if path.end == to && path.holding == .torch {
                return path
            }
            
            // Candidates for our next set of decisions
            var nextSteps = [Traversal]()
            
            // Move to each neighbour, holding the same tool
            for point in path.end.cardinalNeighbors(false) {
                if point.validTools().contains(path.holding) {
                    nextSteps.append(Traversal(end: point, holding: path.holding, cost: path.cost + 1))
                }
            }
            
            // Stay where we are and switch tools to anything we aren't using but can
            var tools = path.end.validTools()
            tools.remove(path.holding)
            for tool in tools {
                nextSteps.append(Traversal(end: path.end, holding: tool, cost: path.cost + 7))
            }
            
            // Of all possible next steps, add the ones we haven't seen, or have seen and can now do cheaper
            for step in nextSteps {
                let key = Key(point: step.end, tool: step.holding)
                if seen[key, default: Int.max] > step.cost {
                    pathsToEvaluate.append(step)
                    seen[key] = step.cost
                }
            }
        }
        
        return nil
    }
}

private struct Key: Hashable {
    let point: Point
    let tool: Tool
}

private extension Point {
    func erosionLevel() -> Int {
        if erosionLevels[self] == nil {
            var geo = 0
            if [.zero, target].contains(self) {
                geo = 0
            } else if y == 0 { geo = x * 16807 }
            else if x == 0 { geo = y * 48271 }
            else { geo = left().erosionLevel() * up().erosionLevel() }
            erosionLevels[self] = (geo + depth) % 20183
        }
        return erosionLevels[self, default: 0]
    }
    
    func validTools() -> Set<Tool> {
        switch self {
        case .zero, target: return [.torch]
        default: return Terrain.byErosionLevel(erosionLevel()).tools
        }
    }
}

private struct Traversal {
    let end: Point
    let holding: Tool
    let cost: Int
    
    public static func == (lhs: Traversal, rhs: Traversal) -> Bool {
        return lhs.cost == rhs.cost
    }
}

private enum Tool {
    case torch, climbing, neither
}

private struct Terrain {
    let modVal: Int
    let tools: Set<Tool>
    
    static let rocky = Terrain(modVal: 0, tools: [.climbing, .torch])
    static let wet = Terrain(modVal: 1, tools: [.climbing, .neither])
    static let narrow = Terrain(modVal: 2, tools: [.torch, .neither])
    
    static let values = [rocky, wet, narrow]
    static func byErosionLevel(_ level: Int) -> Terrain {
        values.first(where: { $0.modVal == level % 3 })!
    }
}
