import Foundation
import StandardLibraries

public struct Day12 {
    public func part1(_ input: [String]) -> Int {
        var point = Point.zero
        var direction = Direction.e
        
        for instruction in input {
            var instruction = instruction
            let action = instruction.removeFirst()
            let value = Int(instruction)!
            
            switch action {
            case "N": point = point.add(direction: .n, distance: value)
            case "S": point = point.add(direction: .s, distance: value)
            case "E": point = point.add(direction: .e, distance: value)
            case "W": point = point.add(direction: .w, distance: value)
                
            case "L":
                for _ in 0..<value / 90 {
                    direction = direction.rotateLeft()
                }
                
            case "R":
                for _ in 0..<value / 90 {
                    direction = direction.rotateRight()
                }
                
            case "F": point = point.add(direction: direction, distance: value)
            default: break
            }
        }
        
        return abs(point.x) + abs(point.y)
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

            case "F":
                for _ in 0..<value {
                    point = point + wayPoint
                }
                
            default: break
            }
        }
        
        return abs(point.x) + abs(point.y)
    }
}
