//
//  Day18.swift
//  Year2019
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import GameplayKit

class MultiPathFinder {
    private var rawMap = [Point:Int]()
    
    private let map1: [Point:Int]
    private let map2: [Point:Int]
    private let map3: [Point:Int]
    private let map4: [Point:Int]
    
    private let pathFinder1: PathFinder
    private let pathFinder2: PathFinder
    private let pathFinder3: PathFinder
    private let pathFinder4: PathFinder
    
    private let keys: [Point:Int]
    private var cachedResults = [String:Int]()

    private var visitedKeys = [Int]()
    private var pathFinders = [PathFinder]()
    private var pathFinderIndex = 0
    private var tempResult = 0
    internal var isFinished: Bool {
        return pathFinders.reduce(true) { $0 && $1.isFinished }
    }
    

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
        
        map1 = rawMap.filter { $0.key.x <= midX && $0.key.y <= midY }
        map2 = rawMap.filter { $0.key.x >= midX && $0.key.y <= midY }
        map3 = rawMap.filter { $0.key.x <= midX && $0.key.y >= midY }
        map4 = rawMap.filter { $0.key.x >= midX && $0.key.y >= midY }
        
        pathFinder1 = PathFinder(map1, id: 1)
        pathFinder2 = PathFinder(map2, id: 2)
        pathFinder3 = PathFinder(map3, id: 3)
        pathFinder4 = PathFinder(map4, id: 4)
                
        pathFinders = [pathFinder1, pathFinder2, pathFinder3, pathFinder4]
        
        var allKeys = [Point:Int]()
        pathFinders.forEach { pathFinder in
            _ = pathFinder.keys.map { allKeys[$0.key] = $0.value }
        }
        keys = allKeys
        
//        printAllMaps()
    }
    
    private func incrementPathFinderIndex() {
        guard !isFinished else { return }
        pathFinderIndex += 1
        if pathFinderIndex >= pathFinders.count { pathFinderIndex = 0 }
        if pathFinders[pathFinderIndex].isFinished { incrementPathFinderIndex() }
    }

    func calculateShortestPathToUnlockAllDoors() -> Int {
        let result = calculate(remainingKeys: keys, visitedKeys: [])
        print("Cache count", cachedResults.count)
        return result
    }
    
    private func printAllMaps() {
        print("===========================================================")
        pathFinders.forEach {
            let startPoint = $0.startingPoint!
            $0.visitedKeys = visitedKeys
            $0.drawGridMap($0.map, position: startPoint)
        }
        print("===========================================================")
    }
    
    private func remainingKeys(_ pathFinder: PathFinder, visited: [Int]) -> [Point:Int] {
        var keys = pathFinder.keys
        visited.forEach { key in
            let point = keys.first(where: { $0.value == key })?.key
            if let point = point {
                keys.removeValue(forKey: point)
            }
        }
        return keys
    }
}

extension MultiPathFinder {
    func resetMap() {
        pathFinder1.resetMap()
        pathFinder2.resetMap()
        pathFinder3.resetMap()
        pathFinder4.resetMap()
    }
    
    func removeVisitedKeys() {
        pathFinder1.removeVisitedKeys(visitedKeys)
        pathFinder2.removeVisitedKeys(visitedKeys)
        pathFinder3.removeVisitedKeys(visitedKeys)
        pathFinder4.removeVisitedKeys(visitedKeys)
    }
    
    private func pathFinderContaining(_ key: Int) -> PathFinder {
        return pathFinders.first { $0.keys.contains { $0.value == key } }!
        
    }
    
    func calculate(remainingKeys: [Point : Int], visitedKeys: [Int]) -> Int {
        var journeyDistance = Int.max
//        printAllMaps()
        for key in remainingKeys {
            self.visitedKeys = visitedKeys
            resetMap()
            removeVisitedKeys()
            let pathFinder = pathFinderContaining(key.value)
            let startingPoint = pathFinder.calculatePosition(visitedKeys)
            let distance = pathFinder.distance(startingPoint, key.key)
            if distance > 0 {
                let position = key.key
                var keys = remainingKeys
                keys.removeValue(forKey: position)
                if keys.isEmpty {
                    self.visitedKeys.append(key.value)
                    if distance < journeyDistance {
                        journeyDistance = distance
                    }
                } else {
                    let newID = pathFinder.generateCacheID(keys, position: position) + visitedKeys.map({ $0.toAscii()! }).joined()
                    if let result = cachedResults[newID] {
                        if distance + result < journeyDistance {
                            journeyDistance = distance + result
                        }
//
//                        var updatedKeys = visitedKeys
//                        updatedKeys.append(key.value)
//                        let nextDistance = calculate(remainingKeys: keys, visitedKeys: updatedKeys)
//                        if nextDistance != result {
//                            print("Cache fail", result, nextDistance, newID, visitedKeys.map({ $0.toAscii()! }).joined(), startingPoint)
//                        }
//                        cachedResults[newID] = nextDistance
//                        if distance + nextDistance < journeyDistance {
//                            journeyDistance = distance + nextDistance
//                        }
                    } else {
                        var updatedKeys = visitedKeys
                        updatedKeys.append(key.value)
                        let nextDistance = calculate(remainingKeys: keys, visitedKeys: updatedKeys)
                        cachedResults[newID] = nextDistance
                        if distance + nextDistance < journeyDistance {
                            journeyDistance = distance + nextDistance
                        }
                    }
                }
            }
        }

        return journeyDistance
    }
}

class PathFinder {
    let id: Int
    let map: GKGridGraph<GKGridGraphNode>
    var rawMap = [Point:Int]()
    var startingPoint: Point?
    
    let start = "@".toAscii().first!
    let wall = "#".toAscii().first!
    let empty = ".".toAscii().first!
    
    var keys = [Point:Int]()
    var doorsData = [Point:Int]()
    var isFinished = false
    var visitedKeys = [Int]()
    
    init(_ input: [String]) {
        id = 1
        map = GKGridGraph(
            fromGridStartingAt: [0,0],
            width: Int32(input[0].count),
            height: Int32(input.count),
            diagonalsAllowed: false
        )
        
        for y in 0..<input.count {
            var row = input[y]
            for x in 0..<input[0].count {
                let tile = row.removeFirst()
                rawMap[Point(x: x, y: y)] = String(tile).toAscii().first!
            }
        }
        
        fillMap()
    }
    
    init(_ input: [Point:Int], id: Int = 1) {
        self.id = id
        let (minX,minY,maxX,maxY) = calculateMapDimensions(input)
        map = GKGridGraph(
            fromGridStartingAt: [Int32(minX),Int32(minY)],
            width: Int32(maxX-minX),
            height: Int32(maxY-minY),
            diagonalsAllowed: false
        )
        
        rawMap = input
        
        fillMap()
    }
    
    func calculateShortestPathToUnlockAllDoors() -> Int {
        guard let startingPoint = startingPoint else { return -1 }
        let journeyDistance = calculate(startingPoint: startingPoint, remainingKeys: keys, visitedKeys: [])
        return journeyDistance
    }
    
    func hasValidPath(startingPoint: Point, remainingKeys: [Point : Int], visitedKeys: [Int]) -> Bool {
        guard !isFinished else { return false }
        self.visitedKeys = visitedKeys
        resetMaps()
        for key in remainingKeys {
            if self.distance(startingPoint, key.key) != -1 {
                return true
            }
        }
        return false
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
            resetMaps()
            let distance = self.distance(startingPoint, key.key)
            if distance > 0 {
                let position = key.key
                var keys = remainingKeys
                keys.removeValue(forKey: position)
                if keys.isEmpty {
                    isFinished = true
                    self.visitedKeys.append(key.value)
                    if distance < journeyDistance {
                        journeyDistance = distance
                    }
                } else {
                    let newID = generateCacheID(keys, position: position)
                    if let result = cachedResults[newID] {
                        if distance + result < journeyDistance {
                            journeyDistance = distance + result
                        }
                    } else {
                        var updatedKeys = visitedKeys
                        updatedKeys.append(key.value)
                        let nextDistance = calculate(startingPoint: position, remainingKeys: keys, visitedKeys: updatedKeys)
                        cachedResults[newID] = nextDistance
                        if distance + nextDistance < journeyDistance {
                            journeyDistance = distance + nextDistance
                        }
                    }
                }
            }
        }
        
        return journeyDistance
    }
    
    private func resetMaps() {
        resetMap()
        removeVisitedKeys()
    }
    
    func removeVisitedKeys() {
        removeVisitedKeys(visitedKeys)
    }
    
    func removeVisitedKeys(_ visited: [Int]) {
        for key in visited {
            removeDoor(key)
        }
    }
    
    func resetMap() {
        // Find Doors
        let nodesToRemove = doorsData.compactMap { return map.node(atGridPosition: $0.key.vector) }
        
        // Remove non traversable tiles
        map.remove(nodesToRemove)
    }
    
    func generateCacheID(_ keys: [Point:Int], position: Point) -> String {
        let prefix = "id:\(id):x:\(position.x):y:\(position.y)"
        return prefix + keys.map({ $0.value.toAscii()! }).sorted().joined()
    }
    
    func drawGridMap(_ map: GKGridGraph<GKGridGraphNode>, position: Point) {
        var rawData = [Point:Int]()
        for y in Int(map.gridOrigin.y)..<Int(map.gridOrigin.y)+Int(map.gridHeight) {
            for x in Int(map.gridOrigin.x)..<Int(map.gridOrigin.x)+Int(map.gridWidth) {
                let point = Point(x: x, y: y)
                rawData[point] = map.node(atGridPosition: point.vector) == nil ? 1 : 0
            }
        }
        rawData[position] = 2
        print("Doors", doorsData.map { $0.value.toAscii()! }.joined())
        _ = doorsData.map {
            if map.node(atGridPosition: $0.key.vector) == nil {
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
    
    func distance(_ start: Point, _ end: Point) -> Int {
        guard
            let startNode = map.node(atGridPosition: start.vector),
            let destinationNode = map.node(atGridPosition: end.vector)
        else { return -1}
        let path = map.findPath(from: startNode, to: destinationNode)
        return path.count-1
    }
    
    func removeDoor(_ key: Int) {
        let doorKey = key.toAscii()!.uppercased().toAscii().first!
        let weakTile = doorsData.first { $0.value == doorKey }
        guard let tile = weakTile else { return }
        let node = GKGridGraphNode(gridPosition: tile.key.vector)
        map.add([node])
        map.connectToAdjacentNodes(node: node)
    }
    
    private func addDoor(_ point: Point) {
        let node = map.node(atGridPosition: point.vector)!
        map.remove([node])
    }
    
    private func fillMap() {
        var nodesToRemove = [GKGridGraphNode]()
        // Find Walls
        _ = rawMap.filter { $0.value == wall }.map {
            if let node = map.node(atGridPosition: $0.key.vector) {
                nodesToRemove.append(node)
            }
        }
        
        // Find Doors
        doorsData = rawMap.filter { CharacterSet.uppercaseLetters.contains(UnicodeScalar($0.value)!) }
        
        // Remove Door Tiles
        _ = doorsData.map {
            if let node = map.node(atGridPosition: $0.key.vector) {
                nodesToRemove.append(node)
            }
        }
        
        // Find Keys
        let keysData = rawMap.filter { CharacterSet.lowercaseLetters.contains(UnicodeScalar($0.value)!) }.map { keys[$0.key] = $0.value }
        
        // Remove non traversable tiles
        map.remove(nodesToRemove)
        
        print("Doors:", doorsData.count, "Keys:", keysData.count)
        
        // Find starting point
        startingPoint = rawMap.first { $0.value == start }!.key
    }
}
