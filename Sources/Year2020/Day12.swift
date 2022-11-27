import Foundation
import StandardLibraries

public struct Day12 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var point = Point.zero
        var direction = CompassDirection.e
        
        for instruction in input {
            var instruction = instruction
            let action = instruction.removeFirst()
            let value = Int(instruction)!
            
            switch action {
            case "N": point = point.add(direction: .n, distance: value)
            case "S": point = point.add(direction: .s, distance: value)
            case "E": point = point.add(direction: .e, distance: value)
            case "W": point = point.add(direction: .w, distance: value)
            case "L": direction = direction.rotateLeft(times: value / 90)
            case "R": direction = direction.rotateRight(times: value / 90)
            case "F": point = point.add(direction: direction, distance: value)
            default: break
            }
        }
        
        return point.manhattanDistance
    }
    
    public func part2(_ input: [String]) -> Int {
        var point = Point.zero
        var wayPoint = Point(x: 10, y: 1)
        
        for instruction in input {
            var instruction = instruction
            let action = instruction.removeFirst()
            let value = Int(instruction)!
            
            switch action {
            case "N": wayPoint = wayPoint.add(direction: .n, distance: value)
            case "S": wayPoint = wayPoint.add(direction: .s, distance: value)
            case "E": wayPoint = wayPoint.add(direction: .e, distance: value)
            case "W": wayPoint = wayPoint.add(direction: .w, distance: value)
            case "L": wayPoint = wayPoint.rotateLeft(angle: value)
            case "R": wayPoint = wayPoint.rotateRight(angle: value)
            case "F": point = point + wayPoint * value
            default: break
            }
        }
        
        return point.manhattanDistance
    }
}
