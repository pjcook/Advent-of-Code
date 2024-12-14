import Foundation
import StandardLibraries

public struct Day14 {
    public init() {}
    
    public func part1(_ input: [String], boardSize: Point, iterations: Int) -> Int {
        let robots = parse(input)
        
        for _ in (0..<iterations) {
            for robot in robots {
                robot.move(on: boardSize)
            }
        }
        
        var tl = 0
        var tr = 0
        var bl = 0
        var br = 0
        let halfWidth = boardSize.x / 2
        let halfHeight = boardSize.y / 2
        
        for robot in robots {
            switch (robot.point.x, robot.point.y) {
            case (0..<halfWidth, 0..<halfHeight):
                tl += 1
            case (halfWidth+1...boardSize.x, 0..<halfHeight):
                tr += 1
            case (0..<halfWidth, halfHeight+1...boardSize.y):
                bl += 1
            case (halfWidth+1...boardSize.x, halfHeight+1...boardSize.y):
                br += 1
            default:
                continue
            }
        }
        
        return tl * tr * bl * br
    }
    
    public func part2(_ input: [String], boardSize: Point) -> Int {
        let robots = parse(input)
        var i = 0
        
        outerloop: while true {
            i += 1

            for robot in robots {
                robot.move(on: boardSize)
            }
            
            let robotPositions = robots.map(\.point)
            for y in (0..<boardSize.y) {
                var beginning: Point?
                for x in (0..<boardSize.x) {
                    if robotPositions.contains(Point(x, y)) {
                        if beginning == nil {
                            beginning = Point(x, y)
                        } else if x - beginning!.x >= 30 {
                            break outerloop
                        }
                    } else {
                        beginning = nil
                    }
                }
            }
        }

        var grid = Grid<String>(size: boardSize, fill: ".")
        for robot in robots {
            grid[robot.point] = "#"
        }
        grid.draw()

        return i
    }
    
    final class Robot: Hashable {
        static func == (lhs: Day14.Robot, rhs: Day14.Robot) -> Bool {
            lhs.point == rhs.point && lhs.velocity == rhs.velocity
        }
        
        func hash(into hasher: inout Hasher) {
            var hasher = Hasher()
            hasher.combine(point)
            hasher.combine(velocity)
        }
        
        var point: Point
        let velocity: Point
        
        init(point: Point, velocity: Point) {
            self.point = point
            self.velocity = velocity
        }
        
        func move(on board: Point) {
            point = point + velocity
            if point.isValid(max: board) { return }
            
            if point.x < 0 { point.x += board.x }
            if point.x >= board.x { point.x -= board.x }
            if point.y < 0 { point.y += board.y }
            if point.y >= board.y { point.y -= board.y }
        }
    }
}

extension Day14 {
    func parse(_ input: [String]) -> [Robot] {
        var robots = [Robot]()
        
        for line in input {
            // p=0,4 v=3,-3
            let parts = line.split(separator: " ").map {
                let values = $0.dropFirst(2).split(separator: ",").map { Int($0)! }
                return Point(values[0], values[1])
            }
            robots.append(Robot(point: parts[0], velocity: parts[1]))
        }
        
        return robots
    }
}
