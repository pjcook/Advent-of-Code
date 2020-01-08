//
//  Day18.swift
//  Year2019
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import GameplayKit

struct Path {
    let start: Point
    let end: Point
    let distance: Int
    let doors: [Int]
    let path: [Point]
}

class MultiPathFinder {
    private var rawMap = [Point:Int]()
    private let keys: [Point:Int]
    private var pathFinders = [PathFinder]()
    private var tempResult = Int.max

    init(_ input: [String]) {
        for y in 0..<input.count {
            var row = input[y]
            for x in 0..<input[0].count {
                let tile = row.removeFirst()
                rawMap[Point(x: x, y: y)] = String(tile).toAscii().first!
            }
        }
        let midY = input.count / 2
        let midX = input[0].count / 2
        
        pathFinders = [
            PathFinder(rawMap.filter { $0.key.x <= midX && $0.key.y <= midY }, id: 1),
            PathFinder(rawMap.filter { $0.key.x >= midX && $0.key.y <= midY }, id: 2),
            PathFinder(rawMap.filter { $0.key.x <= midX && $0.key.y >= midY }, id: 3),
            PathFinder(rawMap.filter { $0.key.x >= midX && $0.key.y >= midY }, id: 4),
        ]
        
        var allKeys = [Point:Int]()
        pathFinders.forEach { pathFinder in
            _ = pathFinder.keys.map { allKeys[$0.key] = $0.value }
        }
        keys = allKeys
    }

    let group = DispatchGroup()
    var queues = [DispatchQueue]()
    
    func calculateShortestPathToUnlockAllDoors() -> Int {
        let validKeys = findValidKeys(remainingKeys: keys, visitedKeys: [], distance: 0)
        
        var journeyDistance = Int.max
        print("Running", validKeys.count)
        for item in validKeys {
            let queue = DispatchQueue(label: String(item.value.0))
            queues.append(queue)
            let analyser = Analyser(findValidKeys: self.findValidKeys, group: self.group)
            queue.async {
                var keys = self.keys
                keys.removeValue(forKey: item.key)
                let distance = item.value.1
                let nextDistance = analyser.calculate(remainingKeys: keys, visitedKeys: [item.value.0], distance: distance)
                if nextDistance != Int.max && distance + nextDistance < journeyDistance {
                    journeyDistance = distance + nextDistance
                }
                
                analyser.leaveGroup()
                print("Finished Thread", item.value.0, Date())
            }
        }
        group.wait()
        return journeyDistance
//        return calculate2(remainingKeys: keys, visitedKeys: [], distance: 0)
    }
        
    private func pathFinderContaining(_ key: Int) -> PathFinder {
        return pathFinders.first { $0.keys.contains { $0.value == key } }!
    }
    
    private func findValidKeys(remainingKeys: [Point: Int], visitedKeys: [Int], distance d: Int) -> [Point: (Int,Int)] {
        var validKeys = [Point: (Int, Int)]()
        _ = remainingKeys.map {
            let pathFinder = pathFinderContaining($0.value)
            let startingPoint = pathFinder.calculatePosition(visitedKeys)
            let distance = pathFinder.distance(startingPoint, $0.key, visitedKeys)
            if distance > 0 && d + distance < 1886 {
                validKeys[$0.key] = ($0.value, distance)
            }
        }
        return validKeys
    }
}

class Analyser {
    private var tempResult = Int.max
    typealias FindKeys = (_ remainingKeys: [Point: Int], _ visitedKeys: [Int], _ d: Int) -> [Point: (Int,Int)]
    
    let findValidKeys: FindKeys
    let group: DispatchGroup
    
    init(findValidKeys: @escaping FindKeys, group: DispatchGroup) {
        self.findValidKeys = findValidKeys
        self.group = group
        group.enter()
    }
    
    func leaveGroup() {
        group.leave()
    }
        
    func calculate(remainingKeys: [Point: Int], visitedKeys: [Int], distance d: Int) -> Int {
        var journeyDistance = Int.max
        
        let validKeys = findValidKeys(remainingKeys, visitedKeys, d)
        
        let sortedValidKeys = validKeys.sorted { (arg0, arg1) -> Bool in
            let (_, (_, distance1)) = arg0
            let (_, (_, distance2)) = arg1
            return distance1 < distance2
        }
        
        for item in sortedValidKeys {
            var keys = remainingKeys
            keys.removeValue(forKey: item.key)
            let distance = item.value.1
            if keys.isEmpty {
                if distance < journeyDistance {
                    journeyDistance = distance
                    if d + distance < tempResult { tempResult = d + distance }
                    print("ValidKeys", "VisitedKeys", (visitedKeys + [item.value.0]).map({ $0.toAscii()! }).joined(), "Distance", d + distance, tempResult)
                }
            } else {
                var updatedKeys = visitedKeys
                updatedKeys.append(item.value.0)
                let nextDistance = calculate(remainingKeys: keys, visitedKeys: updatedKeys, distance: d + distance)
                if nextDistance != Int.max && distance + nextDistance < journeyDistance {
                    journeyDistance = distance + nextDistance
                }
            }
        }
        
        return journeyDistance
    }
    
//    func calculate(remainingKeys: [Point : Int], visitedKeys: [Int]) -> Int {
//        var journeyDistance = Int.max
//        for key in remainingKeys {
//            let pathFinder = pathFinderContaining(key.value)
//            let startingPoint = pathFinder.calculatePosition(visitedKeys)
//            let distance = pathFinder.distance(startingPoint, key.key, visitedKeys)
//            if distance > 0 {
//                let position = key.key
//                var keys = remainingKeys
//                keys.removeValue(forKey: position)
//                if keys.isEmpty {
//                    if distance < journeyDistance {
//                        journeyDistance = distance
//                    }
//                } else {
//                    var updatedKeys = visitedKeys
//                    updatedKeys.append(key.value)
//                    let nextDistance = calculate(remainingKeys: keys, visitedKeys: updatedKeys)
//                    if distance + nextDistance < journeyDistance {
//                        journeyDistance = distance + nextDistance
//                    }
//                }
//            }
//        }
//
//        return journeyDistance
//    }
}

class PathFinder {
    let id: Int
    var rawMap = [Point:Int]()
    var startingPoint: Point?
    
    let start = "@".toAscii().first!
    let wall = "#".toAscii().first!
    let empty = ".".toAscii().first!
    
    var keys = [Point:Int]()
    var doorsData = [Point:Int]()
    var isFinished = false
    var visitedKeys = [Int]()
    private var cachedPaths = [Path]()

    init(_ input: [String]) {
        id = 1
        
        for y in 0..<input.count {
            var row = input[y]
            for x in 0..<input[0].count {
                let tile = row.removeFirst()
                rawMap[Point(x: x, y: y)] = String(tile).toAscii().first!
            }
        }
        
        parseMap()
    }
    
    init(_ input: [Point:Int], id: Int = 1) {
        self.id = id
        rawMap = input
        parseMap()
    }
    
    func calculateShortestPathToUnlockAllDoors() -> Int {
        guard let startingPoint = startingPoint else { return -1 }
        let journeyDistance = calculate(startingPoint: startingPoint, remainingKeys: keys, visitedKeys: [])
        return journeyDistance
    }
    
    func calculatePosition(_ visited: [Int]) -> Point {
        guard let value = visited.reversed().first(where: { keys.values.contains($0) }) else { return startingPoint! }
        return keys.first(where: { $0.value == value })?.key ?? startingPoint!
    }
    
    var cachedResults = [String:Int]()
    internal func calculate(startingPoint: Point, remainingKeys: [Point : Int], visitedKeys: [Int]) -> Int {
        var journeyDistance = Int.max
        for key in remainingKeys {
            self.visitedKeys = visitedKeys
            let distanceToKey = distance(startingPoint, key.key, visitedKeys)
            if distanceToKey > 0 {
                let position = key.key
                var keys = remainingKeys
                keys.removeValue(forKey: position)
                if keys.isEmpty {
                    isFinished = true
                    self.visitedKeys.append(key.value)
                    if distanceToKey < journeyDistance {
                        journeyDistance = distanceToKey
                    }
                } else {
                    let newID = generateCacheID(keys, position: position)
                    if let result = self.cachedResults[newID] {
                        if distanceToKey + result < journeyDistance {
                            journeyDistance = distanceToKey + result
                        }
                    } else {
                        var updatedKeys = visitedKeys
                        updatedKeys.append(key.value)
                        let nextDistance = calculate(startingPoint: position, remainingKeys: keys, visitedKeys: updatedKeys)
                        self.cachedResults[newID] = nextDistance
                        if distanceToKey + nextDistance < journeyDistance {
                            journeyDistance = distanceToKey + nextDistance
                        }
                    }
                }
            }
        }
        
        return journeyDistance
    }
    
    func generateCacheID(_ keys: [Point:Int], position: Point) -> String {
        let prefix = "id:\(id):x:\(position.x):y:\(position.y)"
        return prefix + keys.map({ $0.value.toAscii()! }).sorted().joined()
    }
    
    func remainingDoors(_ visited: [Int]) -> [Int] {
        var doors = doorsData
        
        for data in doors {
            let key = data.value.toAscii()!.lowercased().toAscii().first!
            if visited.contains(key) {
                doors.removeValue(forKey: data.key)
            }
        }
        
        return doors.map { $0.value }
    }
    
    func distance(_ start: Point, _ end: Point, _ visited: [Int]) -> Int {
        let remainingDoors = self.remainingDoors(visited)
        guard let path = cachedPaths.first(where: { $0.start == start && $0.end == end }) else {
            print("ERROR", start, end, visited)
            return -1
        }
        for door in remainingDoors {
            if path.doors.contains(door) {
                return -1
            }
        }
        return path.distance
    }
}

// Parse data and calculate paths
extension PathFinder {
    private func parseMap() {
        var nodesToRemove = [GKGridGraphNode]()
                let (minX,minY,maxX,maxY) = calculateMapDimensions(rawMap)
        let map = GKGridGraph(
            fromGridStartingAt: [Int32(minX),Int32(minY)],
            width: Int32(maxX-minX),
            height: Int32(maxY-minY),
            diagonalsAllowed: false
        )
        
        // Find Walls
        _ = rawMap.filter { $0.value == wall }.map {
            if let node = map.node(atGridPosition: $0.key.vector) {
                nodesToRemove.append(node)
            }
        }
        
        // Remove wall tiles
        map.remove(nodesToRemove)
        nodesToRemove.removeAll()
        
        // Find starting point
        startingPoint = rawMap.first { $0.value == start }!.key

        // Find Doors
        doorsData = rawMap.filter { CharacterSet.uppercaseLetters.contains(UnicodeScalar($0.value)!) }
        
        // Find Keys
        let keysData = rawMap.filter { CharacterSet.lowercaseLetters.contains(UnicodeScalar($0.value)!) }.map { keys[$0.key] = $0.value }
        
        // Populate Paths Cache
        populatePathsCache(keys, startingPoint: startingPoint!, map: map)
        
        for item in keys {
            var remainingKeys = keys
            remainingKeys.removeValue(forKey: item.key)
            populatePathsCache(remainingKeys, startingPoint: item.key, map: map)
        }
        
        print("Doors:", doorsData.count, "Keys:", keysData.count)
    }
    
    private func populatePathsCache(_ keys: [Point:Int], startingPoint: Point, map: GKGridGraph<GKGridGraphNode>) {
        for item in keys {
            let paths = pathFrom(startingPoint, item.key, map: map)
            var doors = [Int]()
            for item in doorsData {
                if paths.contains(item.key) {
                    doors.append(item.value)
                }
            }
            let path = Path(start: startingPoint, end: item.key, distance: paths.count-1, doors: doors, path: paths)
            cachedPaths.append(path)
        }
    }
    
    private func pathFrom(_ start: Point, _ end: Point, map: GKGridGraph<GKGridGraphNode>) -> [Point] {
        guard
            let startNode = map.node(atGridPosition: start.vector),
            let destinationNode = map.node(atGridPosition: end.vector)
        else { return []}
        let path = map.findPath(from: startNode, to: destinationNode)
        return path.compactMap {
            guard let item = $0 as? GKGridGraphNode else { return nil }
            return Point(x: Int(item.gridPosition.x), y: Int(item.gridPosition.y))
        }
    }
}

// Draw map to console
extension PathFinder {
    func drawGridMap(position: Point) {
        var rawData = rawMap
        rawData[position] = 2
        
        print("Doors", doorsData.map { $0.value.toAscii()! }.joined())
        let remaining = remainingDoors(visitedKeys)
        _ = doorsData.map {
            if remaining.contains($0.value) {
                rawData[$0.key] = $0.value
            }
        }
        
        print("Keys", keys.map { $0.value.toAscii()! }.joined())
        print("Keys Visited", visitedKeys.map { $0.toAscii()! }.joined())
        _ = keys.map {
            if !visitedKeys.contains($0.value) {
                rawData[$0.key] = $0.value
            }
        }
        
        drawMap(rawData, tileMap: [1:"⚪️", 0:"⚫️", 2:"🟠"])
    }
}
