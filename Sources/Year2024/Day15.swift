import Foundation
import StandardLibraries

public struct Day15 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var (grid, movements) = parse(input, expandWarehouse: false)
        var robot = grid.point(for: grid.items.firstIndex(of: "@")!)
        grid[robot] = "."
        
        for movement in movements {
            move(robot: &robot, direction: movement, grid: &grid)
        }
                
        var result = 0
        
        for (index, item) in grid.items.enumerated() {
            guard item == "O" else { continue }
            let point = grid.point(for: index)
            result += 100 * point.y + point.x
        }
        
        return result
    }
    
    public func part2(_ input: [String]) -> Int {
        var (grid, movements) = parse(input, expandWarehouse: true)
        var robot = grid.point(for: grid.items.firstIndex(of: "@")!)
        grid[robot] = "."
        let wallCount = grid.items.filter({ $0 == "#" }).count
        let floorCount = grid.items.filter({ $0 == "." }).count
        var i = 0

        for movement in movements {
            i += 1
            move2(robot: &robot, direction: movement, grid: &grid)
//            print(i, movement)
//            var grid2 = grid
//            grid2[robot] = "@"
//            grid2.draw()
//            print()
//            usleep(150000)
        }
                       
        var result = 0

//        print(grid[robot])
//        var grid2 = grid
//        grid2[robot] = "@"
//        grid2.draw()
//        print()

        for (index, item) in grid.items.enumerated() {
            guard item == "[" else { continue }
            let point = grid.point(for: index)
            result += 100 * point.y + point.x
        }
        
        let wallCount2 = grid.items.filter({ $0 == "#" }).count
        let floorCount2 = grid.items.filter({ $0 == "." }).count
        
        assert(wallCount == wallCount2)
        assert(floorCount == floorCount2)
        
        return result
    }
}

extension Day15 {
    func move(robot: inout Point, direction: Direction, grid: inout Grid<String>) {
        var pos = robot
        var foundBox = false
        pos = pos + direction.point
        while grid[pos] != "#" {
            if grid[pos] == "." {
                robot = robot + direction.point
                if foundBox {
                    grid[robot] = "."
                    var pos2 = robot
                    while pos2 != pos {
                        pos2 = pos2 + direction.point
                        grid[pos2] = "O"
                    }
                }
                return
            } else if grid[pos] == "O" {
                foundBox = true
            }
            pos = pos + direction.point
        }
    }
    
    func move2(robot: inout Point, direction: Direction, grid: inout Grid<String>) {
        let pos = robot + direction.point
        if grid[pos] == "#" {
            return
        } else if grid[pos] == "." {
            robot = pos
            grid[robot] = "."
        } else {
            if grid[pos] == "[", moveBox(at: pos, direction: direction, grid: &grid, depth: 1) {
                robot = pos
                grid[robot] = "."
            } else if grid[pos] == "]", moveBox(at: pos + Direction.left.point, direction: direction, grid: &grid, depth: 1) {
                robot = pos
                grid[robot] = "."
            }
        }
    }
    
    func moveBox(at point: Point, direction: Direction, grid: inout Grid<String>, depth: Int) -> Bool {
        var pos = point + direction.point
        switch direction {
        case .up, .down:
            guard grid[pos] != "#" && grid[pos + Direction.right.point] != "#" else { return false }
            assert(grid[point] == "[")
            switch (grid[pos], grid[pos + Direction.right.point]) {
            case (".", "."):
                grid[pos] = "["
                grid[pos + Direction.right.point] = "]"
                grid[point] = "."
                grid[point + Direction.right.point] = "."
                return true
                
            case ("]", "."):
                if moveBox(at: pos + Direction.left.point, direction: direction, grid: &grid, depth: depth + 1) {
                    grid[pos] = "["
                    grid[pos + Direction.right.point] = "]"
                    grid[point] = "."
                    grid[point + Direction.right.point] = "."
                    return true
                }
                
            case (".", "["):
                if moveBox(at: pos + Direction.right.point, direction: direction, grid: &grid, depth: depth + 1) {
                    grid[pos] = "["
                    grid[pos + Direction.right.point] = "]"
                    grid[point] = "."
                    grid[point + Direction.right.point] = "."
                    return true
                }
                
            case ("]", "["):
                if canMoveBox(at: pos + Direction.left.point, direction: direction, grid: &grid, depth: depth + 1) && canMoveBox(at: pos + Direction.right.point, direction: direction, grid: &grid, depth: depth + 1) {
                
                    _ = moveBox(at: pos + Direction.left.point, direction: direction, grid: &grid, depth: depth + 1)
                    _ = moveBox(at: pos + Direction.right.point, direction: direction, grid: &grid, depth: depth + 1)
                    
                    grid[pos] = "["
                    grid[pos + Direction.right.point] = "]"
                    grid[point] = "."
                    grid[point + Direction.right.point] = "."
                    return true
                }
                
            case ("[", "]"):
                if moveBox(at: pos, direction: direction, grid: &grid, depth: depth + 1) {
                    grid[pos] = "["
                    grid[pos + Direction.right.point] = "]"
                    grid[point] = "."
                    grid[point + Direction.right.point] = "."
                    return true
                }
                
            default:
                return false
            }
            
            return false
        case .right, .left:
            assert(grid[point] == "[")
            if grid[pos] != "." && grid[pos] != "#" {
                pos = pos + direction.point
            }
            guard grid[pos] != "#" else { return false }
            
            if grid[pos] == "." {
                if direction == .right {
                    grid[point + direction.point] = "["
                    grid[pos] = "]"
                    grid[point] = "."
                } else {
                    grid[point + direction.point] = "["
                    grid[point] = "]"
                    grid[point - direction.point] = "."
                }
                return true
            } else if moveBox(at: pos, direction: direction, grid: &grid, depth: depth + 1) {
                if direction == .right {
                    grid[point + direction.point] = "["
                    grid[pos] = "]"
                    grid[point] = "."
                } else {
                    grid[point + direction.point] = "["
                    grid[point] = "]"
                    grid[point - direction.point] = "."
                }
                return true
            }
        }
        
        return false
    }
    
    func canMoveBox(at point: Point, direction: Direction, grid: inout Grid<String>, depth: Int) -> Bool {
        var pos = point + direction.point
        switch direction {
        case .up, .down:
            guard grid[pos] != "#" && grid[pos + Direction.right.point] != "#" else { return false }
            assert(grid[point] == "[")
            switch (grid[pos], grid[pos + Direction.right.point]) {
            case (".", "."):
                return true
                
            case ("]", "."):
                if canMoveBox(at: pos + Direction.left.point, direction: direction, grid: &grid, depth: depth + 1) {
                    return true
                }
                
            case (".", "["):
                if canMoveBox(at: pos + Direction.right.point, direction: direction, grid: &grid, depth: depth + 1) {
                    return true
                }
                
            case ("]", "["):
                if canMoveBox(at: pos + Direction.left.point, direction: direction, grid: &grid, depth: depth + 1) && moveBox(at: pos + Direction.right.point, direction: direction, grid: &grid, depth: depth + 1) {
                    return true
                }
                
            case ("[", "]"):
                if canMoveBox(at: pos, direction: direction, grid: &grid, depth: depth + 1) {
                    return true
                }
                
            default:
                return false
            }
            
            return false
        case .right, .left:
            assert(grid[point] == "[")
            if grid[pos] != "." && grid[pos] != "#" {
                pos = pos + direction.point
            }
            guard grid[pos] != "#" else { return false }
            
            if grid[pos] == "." {
                return true
            } else if canMoveBox(at: pos, direction: direction, grid: &grid, depth: depth + 1) {
                return true
            }
        }
        
        return false
    }
    
    func parse(_ input: [String], expandWarehouse: Bool) -> (Grid<String>, [Direction]) {
        var grid: Grid<String>!
        var movements = [Direction]()
        
        var gridLines = [String]()
        var movementLine = ""
        var finishedGrid = false
        
        for line in input {
            if !line.isEmpty && !finishedGrid && !expandWarehouse {
                gridLines.append(line)
            } else if !line.isEmpty && !finishedGrid && expandWarehouse {
                gridLines.append(line.map {
                    switch $0 {
                    case "#": return "##"
                    case "O": return "[]"
                    case ".": return ".."
                    case "@": return "@."
                    default: return ""
                    }
                }.joined())
            } else {
                finishedGrid = true
                movementLine.append(line)
            }
        }
        
        grid = Grid(gridLines)
        movements = movementLine.map {
            switch $0 {
            case "^": return .up
            case "v": return .down
            case "<": return .left
            case ">": return .right
            default: fatalError("Unknown movement \(String($0))")
            }
        }
        
        return (grid, movements)
    }
}
