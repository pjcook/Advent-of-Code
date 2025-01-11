//
//  Day18.swift
//  Year2019
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import GameplayKit
import StandardLibraries

public struct Path {
    public let start: Point
    public let end: Point
    public let distance: Int
    public let doors: [Int]
    public let path: [Point]
}

public struct Job {
    public let remainingKeys: [Point: Int]
    public let visitedKeys: [Int]
    public let distance: Int
}

public class MultiPathFinder {
    private var rawMap = [Point:Int]()
    private let keys: [Point:Int]
    private var pathFinders = [PathFinder]()
    private var tempResult = Int.max //1886

    public init(_ input: [String]) {
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

    public let group = DispatchGroup()
    public var queues = [DispatchQueue]()
    
    public var queue = OperationQueue()
    public var journeyDistance = Int.max
    public func addOperationsToQueue(_ job: Job) {
        if self.queue.operationCount % 1000000 == 0 {
            print("@@@", "VisitedKeys", job.visitedKeys.count, (job.visitedKeys).map({ $0.toAscii()! }).joined(), "Distance", job.distance, self.tempResult, "Queue", self.queue.operationCount)
        }
        
        let validKeys = self.findValidKeys(remainingKeys: job.remainingKeys, visitedKeys: job.visitedKeys, distance: job.distance)
        
        let sortedValidKeys = validKeys.sorted { (arg0, arg1) -> Bool in
            let (_, (_, distance1)) = arg0
            let (_, (_, distance2)) = arg1
            return distance1 < distance2
        }
        
        for item in sortedValidKeys {
            var remainingKeys = job.remainingKeys
            remainingKeys.removeValue(forKey: item.key)
            let distance = item.value.1
            
            guard distance < self.tempResult else { continue }
            
            if remainingKeys.isEmpty {
                if distance < journeyDistance {
                    journeyDistance = distance
                    if distance < self.tempResult {
                        self.tempResult = distance
                    }
                    print("###", "VisitedKeys", (job.visitedKeys + [item.value.0]).map({ $0.toAscii()! }).joined(), "Distance", distance, self.tempResult)
                }
            } else {
                var visitedKeys = job.visitedKeys
                visitedKeys.append(item.value.0)
                let nextJob = Job(remainingKeys: remainingKeys, visitedKeys: visitedKeys, distance: distance)
                self.queue.addOperation {
                    self.addOperationsToQueue(nextJob)
                }
            }
        }
        if queue.operationCount == 1 {
            self.group.leave()
        }
    }
    
    public func calculateShortestPathToUnlockAllDoorsBFS() -> Int {
        queue.maxConcurrentOperationCount = 8
        let job = Job(remainingKeys: keys, visitedKeys: [], distance: 0)
        group.enter()
        queue.addOperation {
            self.addOperationsToQueue(job)
        }
        
        group.wait()
        return journeyDistance
    }
    
    public func calculateShortestPathToUnlockAllDoorsSingleThreaded() -> Int {
        let analyser = Analyser(findValidKeys: self.findValidKeys, generateCacheID: generateCacheID, group: self.group)
        let result = analyser.calculate(remainingKeys: keys, visitedKeys: [], distance: 0)
        analyser.leaveGroup()
        return result
    }
    
    public func calculateShortestPathToUnlockAllDoors() -> Int {
        let validKeys = findValidKeys(remainingKeys: keys, visitedKeys: [], distance: 0)
        
        var journeyDistance = Int.max
        print("Running", validKeys.count)
        for item in validKeys {
            let queue = DispatchQueue(label: String(item.value.0))
            queues.append(queue)
            let analyser = Analyser(findValidKeys: self.findValidKeys, generateCacheID: generateCacheID, group: self.group)
            queue.async {
                var keys = self.keys
                keys.removeValue(forKey: item.key)
                let distance = item.value.1
                let nextDistance = analyser.calculate(remainingKeys: keys, visitedKeys: [item.value.0], distance: distance)
                if nextDistance != Int.max && nextDistance < journeyDistance {
                    journeyDistance = nextDistance
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
            let total = d + distance
            if distance > 0 && total < tempResult {
                validKeys[$0.key] = ($0.value, total)
            }
        }
        return validKeys
    }
    
    private func generateCacheID(_ cost: Int, remainingKeys: [Int]) -> String {
        let prefix = "\(cost)"
        return prefix + remainingKeys.map({ $0.toAscii()! }).sorted().joined()
    }
}

public var tempResult = Int.max
public var cachedResults = [String:Int]()
public let semaphore = DispatchSemaphore(value: 1)
public class Analyser {
    public typealias FindKeys = (_ remainingKeys: [Point: Int], _ visitedKeys: [Int], _ d: Int) -> [Point: (Int,Int)]
    public typealias GenerateCacheID = (_ cost: Int, _ remainingKeys: [Int]) -> String
    
    public let findValidKeys: FindKeys
    public let generateCacheID: GenerateCacheID
    public let group: DispatchGroup
    
    public init(findValidKeys: @escaping FindKeys, generateCacheID: @escaping GenerateCacheID, group: DispatchGroup) {
        self.findValidKeys = findValidKeys
        self.generateCacheID = generateCacheID
        self.group = group
        group.enter()
    }
    
    public func leaveGroup() {
        group.leave()
    }
        
    private var tick = 0
    public func calculate(remainingKeys: [Point: Int], visitedKeys: [Int], distance d: Int) -> Int {
        var journeyDistance = Int.max
        tick += 1
        if tick % 1000000 == 0 {
            print("ValidKeys", "VisitedKeys", visitedKeys.count, (visitedKeys).map({ $0.toAscii()! }).joined(), "Distance", d, tempResult, tick)
        }
        
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
            guard distance < tempResult else { continue }
            if keys.isEmpty {
                print("Solution", "VisitedKeys", (visitedKeys + [item.value.0]).map({ $0.toAscii()! }).joined(), "Distance", distance, tempResult, tick)
                if distance < journeyDistance {
                    journeyDistance = distance
                    if distance < tempResult { tempResult = distance }
                }
            } else {
                let cacheKeys = keys.map { $0.value }
                let newID = generateCacheID(d, cacheKeys)
                semaphore.wait()
                let result = cachedResults[newID]
                semaphore.signal()
                if let result = result {
                    if result < journeyDistance {
                        journeyDistance = result
                    }
                } else {
                    var updatedKeys = visitedKeys
                    updatedKeys.append(item.value.0)
                    let nextDistance = calculate(remainingKeys: keys, visitedKeys: updatedKeys, distance: distance)
                    if nextDistance != Int.max {
                        semaphore.wait()
                        cachedResults[newID] = nextDistance
                        semaphore.signal()
//                        print("Cache", newID, nextDistance, visitedKeys.map { $0.toAscii()! }.joined())
                    }
                    if nextDistance != Int.max && nextDistance < journeyDistance {
                        journeyDistance = nextDistance
                    }
                }
            }
        }
        
        return journeyDistance
    }
}

public class PathFinder {
    public let id: Int
    public var rawMap = [Point:Int]()
    public var startingPoint: Point?
    
    public let start = "@".toAscii().first!
    public let wall = "#".toAscii().first!
    public let empty = ".".toAscii().first!
    
    public var keys = [Point:Int]()
    public var doorsData = [Point:Int]()
    public var isFinished = false
    public var visitedKeys = [Int]()
    private var cachedPaths = [Path]()
    public let keyToDoor: [Int:Int]
    public let doorToKey: [Int:Int]

    public init(id: Int) {
        self.id = id
        var keyToDoor: [Int:Int] = [:]
        var doorToKey: [Int:Int] = [:]
        let keyChars = "abcdefghijklmnopqrstuvwxyz"
        let doorChars = "abcdefghijklmnopqrstuvwxyz".uppercased()
        for (a,b) in zip(keyChars, doorChars) {
            let key = String(a).toAscii().first!
            let door = String(b).toAscii().first!
            keyToDoor[key] = door
            doorToKey[door] = key
        }
        self.keyToDoor = keyToDoor
        self.doorToKey = doorToKey
    }
    
    public convenience init(_ input: [String]) {
        self.init(id: 1)
        
        for y in 0..<input.count {
            var row = input[y]
            for x in 0..<input[0].count {
                let tile = row.removeFirst()
                rawMap[Point(x: x, y: y)] = String(tile).toAscii().first!
            }
        }
        
        parseMap()
    }
    
    public convenience init(_ input: [Point:Int], id: Int = 1) {
        self.init(id: id)
        rawMap = input
        parseMap()
    }
    
    public func calculateShortestPathToUnlockAllDoors() -> Int {
        guard let startingPoint = startingPoint else { return -1 }
        let journeyDistance = calculate(startingPoint: startingPoint, remainingKeys: keys, visitedKeys: [])
        return journeyDistance
    }
    
    public func calculatePosition(_ visited: [Int]) -> Point {
        guard let value = visited.reversed().first(where: { keys.values.contains($0) }) else { return startingPoint! }
        return keys.first(where: { $0.value == value })?.key ?? startingPoint!
    }
    
    public var cachedResults = [String:Int]()
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
    
    public func generateCacheID(_ keys: [Point:Int], position: Point) -> String {
        let prefix = "id:\(id):x:\(position.x):y:\(position.y)"
        return prefix + keys.map({ $0.value.toAscii()! }).sorted().joined()
    }
    
    public func remainingDoors(_ visited: [Int]) -> [Int] {
        return doorsData.compactMap({ visited.contains(doorToKey[$0.value]!) ? nil : $0.value })
    }
    
    public func distance(_ start: Point, _ end: Point, _ visited: [Int]) -> Int {
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
                
        // Populate Paths Cache
        populatePathsCache(keys, startingPoint: startingPoint!, map: map)
        
        for item in keys {
            var remainingKeys = keys
            remainingKeys.removeValue(forKey: item.key)
            populatePathsCache(remainingKeys, startingPoint: item.key, map: map)
        }
        
        print("Starting Point", startingPoint!)
        print("Doors:", doorsData.count, "Keys:", keys.count)
        doorsData.forEach {
            print($0.key, $0.value)
        }
        print()
        keys.forEach {
            print($0.key, $0.value)
        }
        print()
        cachedPaths.forEach {
            print($0.start, $0.end, $0.distance, $0.doors.map { String($0) }.joined(separator: ","))
        }
        print()
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
    public func drawGridMap(position: Point) {
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
