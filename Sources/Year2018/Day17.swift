import Foundation
import StandardLibraries

public struct Day17 {
    public typealias Map = [Point: Strata]
    public init() {}

    public func part1(_ input: [String]) -> Int {
        let spring = Point(x: 500, y: 0)
        var map = parse(input)
        let minY = map.keys.sorted(by: { $0.y < $1.y }).first!.y
        fillUpBuckets(&map, spring)
        return map.filter({ $0.key.y >= minY }).values.filter([.fallingWater, .settledWater].contains).count
    }
    
    public func part2(_ input: [String]) -> Int {
        let spring = Point(x: 500, y: 0)
        var map = parse(input)
        fillUpBuckets(&map, spring)
        return map.values.filter({ $0 == .settledWater }).count
    }

    fileprivate func fillUpBuckets(_ map: inout [Point : Day17.Strata], _ spring: Point) {
        let maxY = map.keys.sorted(by: { $0.y > $1.y }).first!.y
        let down = Point(0, 1)
        let left = Point(-1, 0)
        let right = Point(1, 0)
        let up = Point(0, -1)
        
        var springs = [Point]()
        var water = spring
        var foundLip = false
        var processedSprings = Set<Point>()
//        draw(map)
        while water.y < maxY || !springs.isEmpty {
            //            draw(map)
            if water.y >= maxY || foundLip {
                if springs.isEmpty {
                    break
                }
                water = springs.removeFirst()
            }
            foundLip = false
            let next = water + down
            if map[next] == nil || map[next] == .fallingWater {
                map[next] = .fallingWater
                water = next
            } else if map[next] == .settledWater {
                map[next] = .settledWater
                water = next
            } else if map[next] == .clay {
                
                while !foundLip {
                    var point = water
                    let y = point.y
                    
                    var levelMinX = water.x
                    var levelMaxX = water.x
                    var leftEdge = false
                    var rightEdge = false
                    
                    // find minX
                    while map[point] != .clay && map[point + down] != nil {
                        levelMinX = point.x
                        point = point + left
                        leftEdge = map[point] == .clay
                    }
                    
                    point = water
                    // find maxX
                    while map[point] != .clay && map[point + down] != nil {
                        levelMaxX = point.x
                        point = point + right
                        rightEdge = map[point] == .clay
                    }
                    
                    if leftEdge && rightEdge {
                        for x in (levelMinX...levelMaxX) {
                            map[Point(x,y)] = .settledWater
                        }
                    } else {
                        if !leftEdge && map[Point(levelMinX, y + 1)] != .clay {
                            levelMinX += 1
                        }
                        
                        if !rightEdge && map[Point(levelMaxX, y + 1)] != .clay {
                            levelMaxX -= 1
                        }
                        
                        for x in (levelMinX...levelMaxX) {
                            map[Point(x,y)] = .fallingWater
                        }
                        
                        if !leftEdge {
                            let point = Point(levelMinX - 1, y)
                            map[point] = .fallingWater
                            if !processedSprings.contains(point) {
                                springs.append(point)
                                processedSprings.insert(point)
                            }
                        }
                        if !rightEdge {
                            let point = Point(levelMaxX + 1, y)
                            map[point] = .fallingWater
                            if !processedSprings.contains(point) {
                                springs.append(point)
                                processedSprings.insert(point)
                            }
                        }
                        foundLip = true
                    }
                    
                    if !foundLip {
                        water = Point(water.x, y) + up
                    }
                }
            } else {
                foundLip = true
            }
            //            print(water)
        }
        
//        draw(map)
    }
}

extension Day17 {
    public func draw(_ map: Map) {
        let minX = map.keys.sorted(by: { $0.x < $1.x }).first!.x
        let maxX = map.keys.sorted(by: { $0.x > $1.x }).first!.x + 1
        let maxY = map.keys.sorted(by: { $0.y > $1.y }).first!.y
        var falling = 0
        var settled = 0
        for y in (0...maxY) {
            var line = String(format: "%04i", y)
            for x in (minX...maxX) {
                let point = Point(x, y)
                let tile = map[point, default: .sand]
                line += tile.rawValue
                if tile == .fallingWater {
                    falling += 1
                } else if tile == .settledWater {
                    settled += 1
                }
            }
            print(line)
        }
        print()
        print(falling, settled, falling + settled)
        print()
    }
}

extension Day17 {
    public enum Strata: String {
        case clay = "#"
        case sand = "."
        case fallingWater = "|"
        case settledWater = "~"
    }
    
    public func parse(_ input: [String]) -> Map {
        let regX = try! RegularExpression(pattern: #"x=([\d]*),\sy=([\d]*)\.\.([\d]*)"#)
        let regY = try! RegularExpression(pattern: #"y=([\d]*),\sx=([\d]*)\.\.([\d]*)"#)
        var map = Map()
        
        for line in input {
            if let match = try? regX.match(line) {
                let x = try! match.integer(at: 0)
                let y1 = try! match.integer(at: 1)
                let y2 = try! match.integer(at: 2)
                
                for y in (y1...y2) {
                    map[Point(x, y)] = .clay
                }
            } else if let match = try? regY.match(line) {
                let y = try! match.integer(at: 0)
                let x1 = try! match.integer(at: 1)
                let x2 = try! match.integer(at: 2)
                for x in (x1...x2) {
                    map[Point(x, y)] = .clay
                }
            } else {
                print("oops", line)
            }
        }
        
        return map
    }
}
