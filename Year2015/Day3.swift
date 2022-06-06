import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}
    
    public func part1(_ input: String) -> Int {
        var point = Point.zero
        var points = [point:true]

        for direction in input {
            switch direction {
            case "^": point = point.up()
            case ">": point = point.right()
            case "v": point = point.down()
            case "<": point = point.left()
            default: break
            }
            points[point] = true
        }
        
        return points.count
    }
    
    public func part2(_ input: String) -> Int {
        var santa = Point.zero
        var roboSanta = Point.zero
        var points = [santa:true]
        var santaMove = true

        for direction in input {
            switch direction {
            case "^":
                if santaMove {
                    santa = santa.up()
                } else {
                    roboSanta = roboSanta.up()
                }
                
            case ">":
                if santaMove {
                    santa = santa.right()
                } else {
                    roboSanta = roboSanta.right()
                }
                
            case "v":
                if santaMove {
                    santa = santa.down()
                } else {
                    roboSanta = roboSanta.down()
                }
                
            case "<":
                if santaMove {
                    santa = santa.left()
                } else {
                    roboSanta = roboSanta.left()
                }
                
            default: break
            }
            
            if santaMove {
                points[santa] = true
            } else {
                points[roboSanta] = true
            }
            
            santaMove = !santaMove
        }
        
        return points.count
    }
}
