import Foundation
import StandardLibraries

public class Day22b {
    public init() {}
        
    public func part1(depth: Int, target: Point) -> Int {
        let cave = Cave(depth: depth, target: target)
        return cave.riskLevel(at: target)
    }
    
    public func part2(depth: Int, target: Point) -> Int {
        let cave = Cave(depth: depth, target: target)
        return cave.cheapestPath(to: target)!.cost
    }
}

private enum  Terrain: Int {
    case rocky = 0
    case wet = 1
    case narrow = 2
    
    func equipment(_ point: Point, _ to: Point) -> Set<Equipment> {
        if point == .zero || point == to {
            return [.torch]
        } else {
            return equipment
        }
    }
    
    private var equipment: Set<Equipment> {
        switch self {
        case .rocky: return [.climbingGear, .torch]
        case .wet: return [.climbingGear, .neither]
        case .narrow: return [.torch, .neither]
        }
    }
    
    var symbol: String {
        switch self {
        case .rocky: return "."
        case .wet: return "="
        case .narrow: return "|"
        }
    }
}

private  enum Equipment: Hashable {
    case torch, climbingGear, neither
}

private struct Traversal {
    let end: Point
    let holding: Equipment
    let cost: Int
}

private struct Key: Hashable {
    let point: Point
    let equipment: Equipment
    
    public init(_ point: Point, _ equipment: Equipment) {
        self.point = point
        self.equipment = equipment
    }
}

private class Cave {
    private var erosionLevels = [Point: Int]()
    private let target: Point
    private let depth: Int
    
    init(depth: Int, target: Point) {
        self.depth = depth
        self.target = target
    }
    
    func riskLevel(at: Point) -> Int {
        var risk = 0
        for y in (0...at.y) {
            for x in (0...at.x) {
                risk += erosionLevel(Point(x,y)) % 3
            }
        }
        return risk
    }
    
    func cheapestPath(to: Point) -> Traversal? {
        var seen = [Key(.zero, .torch): 0]
        var pathsToEvaluate = [Traversal(end: .zero, holding: .torch, cost: 0)]
        
        while !pathsToEvaluate.isEmpty {
            print(pathsToEvaluate.count, erosionLevels.count)
            pathsToEvaluate.sort(by: { $0.cost < $1.cost })
            let path = pathsToEvaluate.removeFirst()
            
            // Found it, and holding the correct tool
            if path.end == to && path.holding == .torch {
                return path
            }
            
            // Candidates for our next set of descisions
            var nextSteps = [Traversal]()
            
            // Move to each neighbour, holding the same tool
            for point in path.end.cardinalNeighbors(false) {
                let terrain = self.terrain(at: point)
                if terrain.equipment(point, target).contains(path.holding) {
                    nextSteps.append(Traversal(end: point, holding: path.holding, cost: path.cost + 1))
                }
            }
            
            // Stay where we are and switch tools to anything we are not using but can
            let terrain = self.terrain(at: path.end)
            var tools = terrain.equipment(path.end, target)
            tools.remove(path.holding)
            for tool in tools {
                nextSteps.append(Traversal(end: path.end, holding: tool, cost: path.cost + 7))
            }
            
            // Of all possible next steps, add the ones we haven't seen, or have seen and we can now do cheaper
            for step in nextSteps {
                let key = Key(step.end, step.holding)
                if seen[key, default: Int.max] > step.cost {
                    pathsToEvaluate.append(step)
                    seen[key] = step.cost
                }
            }
        }
        
        return nil
    }
    
    func terrain(at point: Point) -> Terrain {
        return Terrain(rawValue: erosionLevel(point) % 3)!
    }
    
    func erosionLevel(_ point: Point) -> Int {
        if let value = erosionLevels[point] {
            return value
        } else {
            var geo = 0
            if point.y == 0 {
                geo = point.x * 16807
            } else if point.x == 0 {
                geo = point.y * 48271
            } else {
                geo = erosionLevel(point.left()) * erosionLevel(point.up())
            }
            geo = (geo + depth) % 20183
            erosionLevels[point] = geo
            return geo
        }
    }
}
