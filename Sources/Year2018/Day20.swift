import Foundation
import StandardLibraries

public struct Day20 {
    public typealias Map = [Point:Tile]
    public typealias Route = [Point:Point]
    public init() {}
    
    public func part1(_ input: String) -> Int {
        let map = buildMap(input)
        print("Building map")
//        draw(map)
        // find the minimum number of doors to the tile that takes the most number of doors
        print("Find routes")
        let routes = findRoutes(map, point: .zero, currentRoute: Route())
        var route = Route()
        var point = Point.zero
        print("Routes", routes.count)
        for r in routes {
            let end = findEnd(r)
            if r.count > route.count && end != point {
                route = r
                point = end
            } else if r.count < route.count && end == point {
                route = r
                point = end
            }
        }
        
        return route.count
    }
    
    public func part2(_ input: String) -> Int {
        let map = buildMap(input)
        let routes = findRoutes(map, point: .zero, currentRoute: Route())
        var points = Set<Point>()
        for route in routes {
            if route.count >= 1000 {
                var point: Point? = findThousandth(route)
                if let point = point {
                    points.insert(point)
                }
                while point != nil {
                    point = route.first(where: { $0.value == point })?.key
                    if let point = point {
                        points.insert(point)
                    }
                }
            }
        }
        
        return points.count
    }
    
    public func findThousandth(_ route: Route) -> Point {
        var route = route
        var point = route.first(where: { $0.value == .zero })!.key
        route.removeValue(forKey: point)
        var count = 1
        while count < 1000 {
            count += 1
            point = route.first(where: { $0.value == point })!.key
            route.removeValue(forKey: point)
        }
        return point
    }
    
    public func findEnd(_ route: Route) -> Point {
        var route = route
        var point = route.first(where: { $0.value == .zero })!.key
        route.removeValue(forKey: point)
        while !route.isEmpty {
            point = route.first(where: { $0.value == point })!.key
            route.removeValue(forKey: point)
        }
        return point
    }
}

extension Day20 {
    public func draw(_ map: Map) {
        let minX = map.keys.sorted(by: { $0.x < $1.x }).first!.x
        let maxX = map.keys.sorted(by: { $0.x > $1.x }).first!.x
        let minY = map.keys.sorted(by: { $0.y < $1.y }).first!.y
        let maxY = map.keys.sorted(by: { $0.y > $1.y }).first!.y
        
        for y in (minY...maxY) {
            var line = ""
            for x in (minX...maxX) {
                let point = Point(x,y)
                line.append(map[point, default: .unknown].rawValue)
            }
            print(line)
        }
        print()
    }
}

extension Day20 {
    public func findRoutes(_ map: Map, point: Point, currentRoute: Route) -> [Route] {
        var routes = [Route]()
        var continuing = false
        for p in Tile.possibleDoors {
            let next = point + p + p
            if let tile = map[point + p], tile != .wall, currentRoute[next] == nil {
                continuing = true
                var route = currentRoute
                route[next] = point
                routes.append(contentsOf: findRoutes(map, point: next, currentRoute: route))
            }
        }
        
        if !continuing {
            routes.append(currentRoute)
        }
        
        return routes
    }
    
    public func buildMap(_ input: String) -> Map {
        var map = Map()
        
        let point = Point.zero
        add(point, tile: .location, map: &map)
        _ = process(input, point: point, map: &map)
        for item in map.filter({ $0.value == .unknown }) {
            map[item.key] = .wall
        }
        return map
    }
    
    public func process(_ input: String, point: Point, map: inout Map, depth: Int = 1) -> String? {
        var remaining = input
        var next = point
        // possible options ^NEWS(|)$
        while !remaining.isEmpty {
//            print("Depth", depth)
//            draw(map)
            let c = remaining.removeFirst()
            switch c {
            case "^": continue
                
            case "N":
                next = next + Point(0,-1)
                add(next, tile: .doorH, map: &map)
                next = next + Point(0,-1)
                add(next, tile: .room, map: &map)
                
            case "E":
                next = next + Point(1, 0)
                add(next, tile: .doorV, map: &map)
                next = next + Point(1, 0)
                add(next, tile: .room, map: &map)
                
            case "W":
                next = next + Point(-1,0)
                add(next, tile: .doorV, map: &map)
                next = next + Point(-1,0)
                add(next, tile: .room, map: &map)
                
            case "S":
                next = next + Point(0, 1)
                add(next, tile: .doorH, map: &map)
                next = next + Point(0, 1)
                add(next, tile: .room, map: &map)
                
            case "(":
                if let result = process(remaining, point: next, map: &map, depth: depth+1) {
                    remaining = result
                } else {
                    return nil
                }
                
            case "|":
                next = point
                
            case ")":
                return remaining
                
            case "$": return nil
            default: continue
            }
        }
        return nil
    }
    
    public func add(_ point: Point, tile: Tile, map: inout Map) {
        switch tile {
        case .room, .location:
            map[point] = tile
            for p in Tile.corners {
                map[point + p] = .wall
            }
            for p in Tile.possibleDoors {
                if map[point + p] == nil {
                    map[point + p] = .unknown
                }
            }
                                            
        case .unknown, .wall, .doorV, .doorH:
            map[point] = tile
        }
    }
}

extension Day20 {
    public enum Tile: Character {
        case room = "."
        case wall = "#"
        case doorV = "|"
        case doorH = "-"
        case location = "X"
        case unknown = "?"
        
        public static let corners = [
            Point(-1,-1),
            Point(1,-1),
            Point(-1,1),
            Point(1,1)
        ]
        
        public static let possibleDoors = [
            Point(-1,0),
            Point(1,0),
            Point(0,-1),
            Point(0,1)
        ]
    }
}
