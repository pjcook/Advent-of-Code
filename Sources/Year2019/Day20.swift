//
//  Day20.swift
//  Year2019
//
//  Created by PJ COOK on 19/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import GameplayKit
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let columns = input.reduce(0) { max($0, $1.count) }
        let size = Point(x: columns, y: input.count)
        let grid = Grid<String>(input, size: size)
        let portals = calculatePortals(grid)
        let portalEntrances = calculatePortalEntrances(for: portals)
        let start = portals.first(where: { $0.label == "AA" })!.entrance1
        let end = portals.first(where: { $0.label == "ZZ" })!.entrance1
        
        return grid.dijkstra(
            start: start,
            end: end,
            calculateScore: { _ in 1 },
            canEnter: { _ in true },
            nextOptions: { previous, current in
                if let next = portalEntrances[current], next != previous { return [next] }
                return current.cardinalNeighbors(max: grid.bottomRight).filter { grid[$0] == "." }
            })
    }
    
    public func part2(_ input: [String]) -> Int {
        let columns = input.reduce(0) { max($0, $1.count) }
        let cleanInput = input.compactMap { $0.isEmpty ? nil : $0 }
        let size = Point(x: columns, y: cleanInput.count)
        let grid = Grid<String>(cleanInput, size: size)
        let portals = calculatePortals(grid)
        let portalEntrances = calculatePortalEntrances(for: portals)
        let start = portals.first(where: { $0.label == "AA" })!.entrance1
        let end = portals.first(where: { $0.label == "ZZ" })!.entrance1
        let routes = calculateRoutes(for: grid, portals: portals, entrances: portalEntrances)
        
        return grid.dijkstra(
            start: Vector(x: start.x, y: start.y, z: 0),
            end: Vector(x: end.x, y: end.y, z: 0),
            calculateScore: { from, to in
                let fromPoint = portalEntrances[Point(from)] ?? Point(from)
                let toPoint = Point(to)
                guard fromPoint != toPoint else { return 0 }
                return (routes[fromPoint]?.first(where: { $0.to == toPoint && $0.from == fromPoint })?.distance ?? 1) + 1
            },
            canEnter: { vector in vector.z == 0 || ![start, end].contains(Point(vector)) },
            nextOptions: { previous, current in
                let previousPoint = Point(previous)
                let currentPoint = Point(current)
                
                if previousPoint == currentPoint {
                    return routes[currentPoint]!
                        .map({ $0.to })
                        .map({ Vector(x: $0.x, y: $0.y, z: current.z) })
                } else {
                    let dy = currentPoint.isOnOuterEdge(of: grid) ? -1 : 1
                    guard current.z + dy >= 0 else { return [] }
                    let newPoint = portalEntrances[currentPoint]!
                    return routes[newPoint]!
                        .map({ $0.to })
                        .map({ Vector(x: $0.x, y: $0.y, z: current.z + dy) })
                }
            }
        )
    }
}

extension Point {
    func isOnOuterEdge(of grid: Grid<String>) -> Bool {
        [2, grid.bottomRight.x - 3].contains(x) || [2, grid.rows - 3].contains(y)
    }
}

extension Day20 {
    typealias Portals = Set<Portal>
    typealias Routes = [Point: [Route]]
    
    struct Route: Hashable {
        let from: Point
        let to: Point
        let distance: Int
        
        var reversed: Route { Route(from: to, to: from, distance: distance) }
    }
    
    struct PortalPoint: Hashable {
        let point: Point
        let direction: Direction
    }
    
    struct Portal: Hashable {
        let label: String
        let entrance1: Point
        let entrance1Direction: Direction
        let entrance2: Point
        let entrance2Direction: Direction
    }
    
    func calculateRoutes(for grid: Grid<String>, portals: Portals, entrances: [Point: Point]) -> Routes {
        var routes = Routes()
        var portalPoints = Set<Point>()
        portals.forEach {
            portalPoints.insert($0.entrance1)
            portalPoints.insert($0.entrance2)
        }

        for start in portalPoints {
            var queue = [[Point]]()
            queue.append([start])
            var calculatingRoutes = Set<Route>()
            
            while !queue.isEmpty {
                let currentPath = queue.removeFirst()
                let currentPoint = currentPath.last!
                
                for next in currentPoint.cardinalNeighbors(in: grid, matching: ["."]) where !currentPath.contains(next) {
                    let path = currentPath + [next]
                    queue.append(path)
                    if entrances.keys.contains(next) {
                        let route = Route(from: path.first!, to: next, distance: path.count-1)
                        calculatingRoutes.insert(route)
                        calculatingRoutes.insert(route.reversed)
                    }
                }
            }
            
            for route in calculatingRoutes {
                var list = routes[route.from, default: []]
                if !list.contains(route) {
                    list.append(route)
                }
                routes[route.from] = list
            }
        }
        
        return routes
    }
    
    func calculatePortalEntrances(for portals: Portals) -> [Point: Point] {
        var entrances = [Point: Point]()
        
        for portal in portals {
            guard !["AA", "ZZ"].contains(portal.label) else { continue }
            entrances[portal.entrance1] = portal.entrance2
            entrances[portal.entrance2] = portal.entrance1
        }
        
        return entrances
    }
    
    func calculatePortals(_ grid: Grid<String>) -> Portals {
        var portals = Portals()
        var portalLabelPoints = [Point: String]()
        for (index, value) in grid.items.enumerated() where !["#","."," "].contains(value) {
            portalLabelPoints[grid.point(for: index)] = value
        }
        var seen = Set<String>()
        
        var portalPoints = [String: PortalPoint]()
        for (point, value) in portalLabelPoints {
            var label = value
            if let value2 = portalLabelPoints[point.right()] {
                label += value2
                guard !seen.contains(label) else { continue }
                var portalPoint = point.right().right()
                var direction: Direction = .right
                if point.left().x >= 0, grid[point.left()] == "." {
                    portalPoint = point.left()
                    direction = .left
                }
                
                if ["AA", "ZZ"].contains(label) {
                    let portal = Portal(label: label, entrance1: portalPoint, entrance1Direction: direction, entrance2: portalPoint, entrance2Direction: direction)
                    portals.insert(portal)
                    seen.insert(label)
                }
                
                if let pp1 = portalPoints[label] {
                    if pp1.point == portalPoint { continue }
                    let portal = Portal(label: label, entrance1: pp1.point, entrance1Direction: pp1.direction, entrance2: portalPoint, entrance2Direction: direction)
                    portals.insert(portal)
                    seen.insert(label)
                } else {
                    portalPoints[label] = PortalPoint(point: portalPoint, direction: direction)
                }
                
            } else if let value2 = portalLabelPoints[point.left()] {
                label = value2 + label
                guard !seen.contains(label) else { continue }
                var portalPoint = point.left().left()
                var direction: Direction = .left
                if point.right().x < grid.columns, grid[point.right()] == "." {
                    portalPoint = point.right()
                    direction = .right
                }
                
                if ["AA", "ZZ"].contains(label) {
                    let portal = Portal(label: label, entrance1: portalPoint, entrance1Direction: direction, entrance2: portalPoint, entrance2Direction: direction)
                    portals.insert(portal)
                    seen.insert(label)
                }
                
                if let pp1 = portalPoints[label] {
                    if pp1.point == portalPoint { continue }
                    let portal = Portal(label: label, entrance1: pp1.point, entrance1Direction: pp1.direction, entrance2: portalPoint, entrance2Direction: direction)
                    portals.insert(portal)
                    seen.insert(label)
                } else {
                    portalPoints[label] = PortalPoint(point: portalPoint, direction: direction)
                }
                
            } else if let value2 = portalLabelPoints[point.up()] {
                label = value2 + label
                guard !seen.contains(label) else { continue }
                var portalPoint = point.up().up()
                var direction: Direction = .up
                if point.down().y < grid.rows, grid[point.down()] == "." {
                    portalPoint = point.down()
                    direction = .down
                }
                
                if ["AA", "ZZ"].contains(label) {
                    let portal = Portal(label: label, entrance1: portalPoint, entrance1Direction: direction, entrance2: portalPoint, entrance2Direction: direction)
                    portals.insert(portal)
                    seen.insert(label)
                }
                
                if let pp1 = portalPoints[label] {
                    if pp1.point == portalPoint { continue }
                    let portal = Portal(label: label, entrance1: pp1.point, entrance1Direction: pp1.direction, entrance2: portalPoint, entrance2Direction: direction)
                    portals.insert(portal)
                    seen.insert(label)
                } else {
                    portalPoints[label] = PortalPoint(point: portalPoint, direction: direction)
                }
                
            } else if let value2 = portalLabelPoints[point.down()] {
                label += value2
                guard !seen.contains(label) else { continue }
                var portalPoint = point.down().down()
                var direction: Direction = .down
                if point.up().y >= 0, grid[point.up()] == "." {
                    portalPoint = point.up()
                    direction = .up
                }
                
                if ["AA", "ZZ"].contains(label) {
                    let portal = Portal(label: label, entrance1: portalPoint, entrance1Direction: direction, entrance2: portalPoint, entrance2Direction: direction)
                    portals.insert(portal)
                    seen.insert(label)
                }
                
                if let pp1 = portalPoints[label] {
                    if pp1.point == portalPoint { continue }
                    let portal = Portal(label: label, entrance1: pp1.point, entrance1Direction: pp1.direction, entrance2: portalPoint, entrance2Direction: direction)
                    portals.insert(portal)
                    seen.insert(label)
                } else {
                    portalPoints[label] = PortalPoint(point: portalPoint, direction: direction)
                }
                
            } else {
                fatalError( "Could not find portal label for \(point)")
            }
        }
        
        return portals
    }
}
