//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public class Day24 {
    public enum Element: String {
        case ground = "."
        case wall = "#"
        case up = "^"
        case down = "v"
        case left = "<"
        case right = ">"
        case santa = "S"
        
        var direction: Direction? {
            switch self {
            case .up: return .up
            case .down: return .down
            case .left: return .left
            case .right: return .right
            default: return nil
            }
        }
    }
    
    public struct QueueItem: Hashable {
        let grid: Grid<[Day24.Element]>
        let distance: Int
        let signature: String

        public init(grid: Grid<[Day24.Element]>, distance: Int) {
            self.grid = grid
            self.distance = distance
            self.signature = Self.calculateSignature(grid)
        }
        
        public static func calculateSignature(_ grid: Grid<[Day24.Element]>) -> String {
            var result = ""
            for y in (0..<grid.rows) {
                for x in (0..<grid.columns) {
                    let item = grid[x,y]
                    if item.isEmpty {
                        result += Element.ground.rawValue
                    } else if item.count == 1 {
                        result += item[0].rawValue
                    } else {
                        result += "\(item.count)"
                    }
                }
            }
            return result
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(signature)
        }
    }
    
    public init() {}
    
    func moveTo(_ startingGrid: Grid<[Day24.Element]>, start: Point, end: Point) -> QueueItem {
        var seen = [String: Bool]()
        var queue = [QueueItem]()
        var best = QueueItem(grid: startingGrid, distance: Int.max)
        queue.append(QueueItem(grid: startingGrid, distance: 0))
        
        // calculate starting positions
        mainLoop: while !queue.isEmpty {
            let nextMove = queue.removeFirst()
            
            //            draw(nextMove.grid)
            guard nextMove.distance + 1 < best.distance else { continue }
            var (newGrid, santa) = calculateNextGrid(nextMove.grid, start: start)
            
            if santa == end {
                if best.distance > nextMove.distance {
                    best = QueueItem(grid: newGrid, distance: nextMove.distance)
                }
                continue
            }
            
            let nextMoveSignature = nextMove.signature
            guard !seen[nextMoveSignature, default: false] else { continue }
            seen[nextMoveSignature] = true
            if seen.count % 5000 == 0 {
                print(queue.count, seen.count, windsLookup.count, nextMove.distance, best.distance)
            }
            
            var validNeighbors = 0
            // Calculate all the places Santa can move to
            for point in santa.cardinalNeighbors(min: Point(1,1), max: Point(newGrid.columns-1, newGrid.rows-1)) {
                //                var gridCopy = Grid(columns: newGrid.columns, items: newGrid.items)
                var gridCopy = newGrid
                
                var destinationElements = gridCopy[point]
                guard destinationElements.isEmpty else { continue }
                destinationElements.append(.santa)
                gridCopy[point] = destinationElements
                
                if point == end, best.distance > nextMove.distance + 1 {
                    best = QueueItem(grid: gridCopy, distance: nextMove.distance + 1)
                }
                
                let signature = QueueItem(grid: gridCopy, distance: nextMove.distance + 1)
                if !seen[signature.signature, default: false] {
                    //                    queue.insert(signature, at: 0)
                    queue.append(signature)
                    validNeighbors += 1
                }
            }
            
            // Waiting grid
            var destinationElements = newGrid[santa]
            guard destinationElements.isEmpty ||
                    (destinationElements.count == 1 && destinationElements[0] == .santa)
            else { continue }
            destinationElements.append(.santa)
            newGrid[santa] = destinationElements
            let signature = QueueItem(grid: newGrid, distance: nextMove.distance + 1)
            if !seen[signature.signature, default: false] {
                //                queue.insert(signature, at: validNeighbors)
                queue.append(signature)
            }
        }
        
        let (newGrid, _) = calculateNextGrid(best.grid, start: start)
        return QueueItem(grid: newGrid, distance: best.distance + 1)
    }
    
    public func part1(_ input: [String]) -> Int {
        var startingGrid = parse(input)
        startingGrid[Point(1,0)] = [.santa]
        return moveTo(startingGrid, start: Point(1,0), end: Point(startingGrid.columns - 2, startingGrid.rows - 2)).distance
    }
    
    public func part2(_ input: [String]) -> Int {
        var startingGrid = parse(input)
        startingGrid[Point(1,0)] = [.santa]
        let leg1 = moveTo(startingGrid, start: Point(1,0), end: Point(startingGrid.columns - 2, startingGrid.rows - 2))
        var grid1 = leg1.grid
        grid1[Point(startingGrid.columns - 2, startingGrid.rows - 1)] = [.santa]
        
        let leg2 = moveTo(grid1, start: Point(startingGrid.columns - 2, startingGrid.rows - 1), end: Point(1,1))
        var grid2 = leg2.grid
        grid2[Point(1,0)] = [.santa]

        let leg3 = moveTo(grid2, start: Point(1,0), end: Point(startingGrid.columns - 2, startingGrid.rows - 2))
        
        return leg1.distance + leg2.distance + leg3.distance
    }
    var windsLookup = [String: Grid<[Day24.Element]>]()
}

extension Day24 {
    func draw(_ grid: Grid<[Day24.Element]>) {
        for y in (0..<grid.rows) {
            var row = ""
            for x in (0..<grid.columns) {
                let item = grid[x,y]
                if item.count == 1 {
                    row += item[0].rawValue
                } else if item.isEmpty {
                    if y == 0 && x == 1 {
                        row += Element.ground.rawValue
                    } else if y == grid.rows - 1 && x == grid.columns - 2 {
                        row += Element.ground.rawValue
                    } else if [0,grid.columns-1].contains(x) || [0,grid.rows-1].contains(y) {
                        row += Element.wall.rawValue
                    } else {
                        row += Element.ground.rawValue
                    }
                } else {
                    row += "\(item.count)"
                }
            }
            print(row)
        }
        print()
    }
    
    public func calculateWindSignature(_ grid: Grid<[Day24.Element]>) -> String {
        var result = ""
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                let item = grid[x,y]
                if item.isEmpty {
                    result += Element.ground.rawValue
                } else if item.count == 1 {
                    if item[0] == .santa {
                        result += Element.ground.rawValue
                    } else {
                        result += item[0].rawValue
                    }
                } else {
                    result += "\(item.count)"
                }
            }
        }
        return result
    }
    
    public func calculateNextGrid(_ grid: Grid<[Day24.Element]>, start: Point) -> (Grid<[Day24.Element]>, Point) {
        let signature = calculateWindSignature(grid)
        let santaIndex = grid.items.firstIndex(of: [.santa])
        let santa = santaIndex != nil ? grid.point(for: santaIndex!) : start
        
        if let nextGrid = windsLookup[signature] {
            return (nextGrid, santa)
        }
        var newGrid = Grid<[Element]>(columns: grid.columns, items: Array(repeating: [], count: grid.columns * grid.rows))
        
        // Calculate new grid
        for y in (1..<grid.rows-1) {
            for x in (1..<grid.columns-1) {
                let point = Point(x,y)
                for element in grid[point] {
                    if let direction = element.direction {
                        let newPoint = calculateMove(point: point, direction: direction, grid: grid)
                        var destinationElements = newGrid[newPoint]
                        destinationElements.append(element)
                        newGrid[newPoint] = destinationElements
                    }
                }
            }
        }
        
        windsLookup[signature] = newGrid
        return (newGrid, santa)
    }
    
    public func calculateMove(point: Point, direction: Direction, grid: Grid<[Element]>) -> Point {
        var newPoint = point + direction.point
        if newPoint.x < 1 {
            newPoint = Point(grid.columns - 2, newPoint.y)
        } else if newPoint.x >= grid.columns - 1 {
            newPoint = Point(1, newPoint.y)
        } else if newPoint.y < 1 {
            newPoint = Point(newPoint.x, grid.rows - 2)
        } else if newPoint.y >= grid.rows - 1 {
            newPoint = Point(newPoint.x, 1)
        }
        return newPoint
    }
    
    public func parse(_ input: [String]) -> Grid<[Element]> {
        var items = [[Element]]()
        
        for line in input {
            line.forEach {
                let element = Element(rawValue: String($0))!
                if element != .ground {
                    items.append([Element(rawValue: String($0))!])
                } else {
                    items.append([])
                }
            }
        }
        
        let columns = input[0].count
        return Grid(columns: columns, items: items)
    }
}
