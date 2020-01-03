//
//  Day18.swift
//  Year2019
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import GameplayKit

class PathFinder {
    let map: GKGridGraph<GKGridGraphNode>
    var rawMap = [Point:Int]()
    var startingPoint: Point?
    
    let start = "@".toAscii().first!
    let wall = "#".toAscii().first!
    let empty = ".".toAscii().first!
    
    var keys = [Point:Int]()
    
    init(_ input: [String]) {
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
        
        fillMap(input)
    }
    
    func calculateShortestPathToUnlockAllDoors() -> Int {
        var journeyDistance = 0
        guard let startingPoint = startingPoint else { return -1 }
        var position = startingPoint
//        print("Starting:", position)
        while !keys.isEmpty {
            var shortestDistance = Int.max
            var key: Point?
            for item in keys {
                let itemDistance = distance(position,item.key)
//                print("Path for:", item.value.toAscii()!, itemDistance, position, item.key)
                if itemDistance > 0, itemDistance < shortestDistance {
                    key = item.key
                    shortestDistance = itemDistance
                }
            }
            if let key = key {
                let keyID = keys[key]!
                removeDoor(keyID)
                print("Picked up key:", keyID.toAscii()!, "at", key, shortestDistance)
                keys.removeValue(forKey: key)
                journeyDistance += shortestDistance
                position = key
            } else {
                let doorsData = rawMap.filter { CharacterSet.uppercaseLetters.contains(UnicodeScalar($0.value)!) }.compactMap {
                    map.node(atGridPosition: $0.key.vector)
                }
                
                doorsData.forEach {
                    print($0.gridPosition, $0.connectedNodes)
                }
                print("oops!")
            }
        }
        
        return journeyDistance
    }
    
    private func distance(_ start: Point, _ end: Point) -> Int {
        guard
            let startNode = map.node(atGridPosition: start.vector),
            let destinationNode = map.node(atGridPosition: end.vector)
        else { return -1}
        let path = map.findPath(from: startNode, to: destinationNode)
        return path.count-1
    }
    
    private func removeDoor(_ key: Int) {
        let doorKey = key.toAscii()!.uppercased().toAscii().first!
        let weakTile = rawMap.first { $0.value == doorKey }
        guard let tile = weakTile else { return }
        let node = GKGridGraphNode(gridPosition: tile.key.vector)
        
        _ = [
            tile.key + Direction.N.point,
            tile.key + Direction.E.point,
            tile.key + Direction.S.point,
            tile.key + Direction.W.point
        ]
            .compactMap { rawMap[$0] != wall ? $0 : nil }
            .map {
                if let connectedNode = map.node(atGridPosition: $0.vector) {
                    node.addConnections(to: [connectedNode], bidirectional: true)
                }
        }
    }
    
    private func addDoor(_ point: Point) {
        let node = map.node(atGridPosition: point.vector)!
        map.remove([node])
    }
    
    private func fillMap(_ input: [String]) {
        var nodesToRemove = [GKGridGraphNode]()
        // Find Walls
        _ = rawMap.filter { $0.value == wall }.map {
            if let node = map.node(atGridPosition: $0.key.vector) {
                nodesToRemove.append(node)
            }
        }
        
        // Find Doors
        let doorsData = rawMap.filter { CharacterSet.uppercaseLetters.contains(UnicodeScalar($0.value)!) }.map {
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
