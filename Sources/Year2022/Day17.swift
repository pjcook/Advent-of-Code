//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day17 {
    let rock = "#"
    let empty = "."
    let fallingRock = "@"
    
    public init() {}
    
    public func part1(_ input: String, numberOfRocks: Int = 2022) -> Int {
        let minX = 0
        let maxX = 7
        var rockPointer = 0
        var inputPointer = 0
        var top = 0
        var added = 0
        
        var tunnel = Set<Point>()
        var seen = [Set<Point>: (Int, Int)]()
        
        func incrementRockPointer() {
            rockPointer += 1
            if rockPointer >= Day17.allRocks.count {
                rockPointer = 0
            }
        }
        
        func incrementInputPointer() {
            inputPointer += 1
            if inputPointer >= input.count {
                inputPointer = 0
            }
        }
        
        func calculateSigniture() -> Set<Point> {
            let maxY = tunnel.map({ $0.y }).sorted().last!
            let results: [Point] = tunnel.compactMap { point in
                guard maxY - point.y <= 50 else { return nil }
                return Point(point.x, maxY - point.y)
            }
            return Set(results)
        }
        
        func draw(points: Set<Point>, currentRock: Set<Point>?) {
            var allPoints = points
            if let currentRock {
                for point in currentRock {
                    allPoints.insert(point)
                }
            }
            let minMax = allPoints.minMax()
            let columns = 7
            let rows = minMax.1.y-minMax.0.y
            var grid = Grid(columns: columns, items: Array(repeating: empty, count: columns * (rows + 1)))
            
            let transition = Point(0,-minMax.0.y)
            for point in points {
                grid[point+transition] = rock
            }
            if let currentRock {
                for point in currentRock {
                    grid[point+transition] = fallingRock
                }
            }
            
            grid.drawUpsidedown()
            print()
        }
        
        func moveRock(rock: Rock) {
            // has to start 3 above last highest point
            var rock = rock.moveUp(by: top + 3)
            
            while true {
                // Get direction
                let direction = input[inputPointer]
                incrementInputPointer()
                
                // Move direction (if possible)
                switch direction {
                case ">":
                    rock = rock.moveRight(maxX: maxX, tunnel: tunnel)
                case "<":
                    rock = rock.moveLeft(minX: minX, tunnel: tunnel)
                default: break
                }

                // Fall down 1 (if possible, else exit)
                let testRock = rock.moveDown(by: 1, tunnel: tunnel)

                // Check if come to rest
                if testRock == rock {
                    for point in rock.points {
                        tunnel.insert(point)
                    }
                    let minMax = tunnel.minMax()
                    top = minMax.1.y + 1
                    break
                }
                
                // Continue
                rock = testRock
//                draw(points: tunnel, currentRock: rock.points)
            }
        }
        
        var i = 0
        while i < numberOfRocks {
            moveRock(rock: Day17.allRocks[rockPointer])
            incrementRockPointer()
            
            if i >= 2022 {
                let signiture = calculateSigniture()
                if let (oldI, oldTop) = seen[signiture] {
                    let dy = top - oldTop
                    let dt = i - oldI
                    let amt = (numberOfRocks - i) / dt
                    added += amt * dy
                    i += amt * dt
                }
                seen[signiture] = (i, top)
            }
            
            i += 1
        }
        
//        draw(points: tunnel, currentRock: nil)
        return top + added
    }
}

extension Day17 {
    public struct Rock: Equatable {
        public let points: Set<Point>
        public func moveRight(maxX: Int, tunnel: Set<Point>) -> Rock {
            let nextPoints = Set(points.map { $0 + Point(1,0) })
            var testTunnel = tunnel
            for point in nextPoints {
                testTunnel.insert(point)
            }
            if tunnel.count + nextPoints.count == testTunnel.count {
                let minMax = nextPoints.minMax()
                if minMax.1.x < maxX {
                    return Rock(points: nextPoints)
                }
            }
            return self
        }
        
        public func moveLeft(minX: Int, tunnel: Set<Point>) -> Rock {
            let nextPoints = Set(points.map { $0 - Point(1,0) })
            var testTunnel = tunnel
            for point in nextPoints {
                testTunnel.insert(point)
            }
            if tunnel.count + nextPoints.count == testTunnel.count {
                let minMax = nextPoints.minMax()
                if minMax.0.x >= minX {
                    return Rock(points: nextPoints)
                }
            }
            return self
        }
        
        public func moveDown(by: Int, tunnel: Set<Point>) -> Rock {
            let nextPoints = Set(points.map { $0 - Point(0,by) })
            let minMax = nextPoints.minMax()
            if minMax.0.y < 0 {
                return self
            }
            
            var testTunnel = tunnel
            for point in nextPoints {
                testTunnel.insert(point)
            }
            if tunnel.count + nextPoints.count == testTunnel.count {
                return Rock(points: nextPoints)
            } else {
                return self
            }
        }
        
        public func moveUp(by: Int) -> Rock {
            let nextPoints = Set(points.map { $0 + Point(0,by) })
            return Rock(points: nextPoints)
        }
    }
}

extension Day17 {
    static let rock1 = Rock(points: [Point(2,0), Point(3,0), Point(4,0), Point(5,0)])
    static let rock2 = Rock(points: [Point(3,0), Point(2,1), Point(3,1), Point(4,1), Point(3,2)])
    static let rock3 = Rock(points: [Point(4,2), Point(4,1), Point(2,0), Point(3,0), Point(4,0)])
    static let rock4 = Rock(points: [Point(2,0), Point(2,1), Point(2,2), Point(2,3)])
    static let rock5 = Rock(points: [Point(2,0), Point(3,0), Point(2,1), Point(3,1)])
    static let allRocks = [rock1, rock2, rock3, rock4, rock5]
}
