//
//  Day20.swift
//  Year2019
//
//  Created by PJ COOK on 19/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import GameplayKit

func parsePlutoMap(_ input: [String]) -> ([Point:Int], [Point:String]) {
    var map = [Point:Int]()
    var portals = [Point:String]()
    let width = input.reduce(0) { max($0, $1.count)}
    
    func getCharacter(_ point: Point) -> String {
        guard point.y >= 0, point.x >= 0, input.count > point.y else { return " " }
        let chars = input[point.y].map { String($0) }
        if chars.count > point.x {
            return chars[point.x]
        }
        return " "
    }
    
    for y in 0..<input.count {
        var row = input[y]
        for x in 0..<width {
            guard !row.isEmpty else { break }
            let char = row.removeFirst()
            let point = Point(x: x, y: y)
            switch char {
            case "#": map[point] = 0
            case ".": map[point] = 1
            case " ": map[point] = 2
            default:
                var label = String(char)
                let charEast = getCharacter(point + Direction.E.point)
                let charSouth = getCharacter(point + Direction.S.point)
                let charNorth = getCharacter(point + Direction.N.point)
                let charWest = getCharacter(point + Direction.W.point)
                var portalPoint = point
                if charEast == "." {
                    label = charWest + label
                    portalPoint = portalPoint + Direction.E.point
                } else if charWest == "." {
                    label += charEast
                    portalPoint = portalPoint + Direction.W.point
                } else if charSouth == "." {
                    label += charNorth
                    portalPoint = portalPoint + Direction.S.point
                } else if charNorth == "." {
                    label = charSouth + label
                    portalPoint = portalPoint + Direction.N.point
                }
                if label.count == 2 {
                    portals[portalPoint] = label
                }
            }
        }
    }
    
    return (map, portals)
}

class PortalMaze {
    let map: GKGridGraph<GKGridGraphNode>
    let rawMap: [Point:Int]
    let keys: [Point:String]
    let startingPoint: Point
    let endPoint: Point
    
    init(rawMap: [Point:Int], keys: [Point:String]) {
        self.rawMap = rawMap
        self.keys = keys
        startingPoint = keys.first(where: { $0.value == "AA" })!.key
        endPoint = keys.first(where: { $0.value == "ZZ" })!.key
        let (minX,minY,maxX,maxY) = calculateMapDimensions(rawMap)
        map = GKGridGraph(
            fromGridStartingAt: [0,0],
            width: Int32(maxX - minX),
            height: Int32(maxY - minY),
            diagonalsAllowed: false
        )
        
        var nodesToRemove = [GKGridGraphNode]()
        
        for y in minY..<maxY {
            for x in minX..<maxX {
                let point = Point(x: x, y: y)
                let value = rawMap[point] ?? 0
                if [0,2].contains(value),
                    let node = map.node(atGridPosition: point.vector) {
                    nodesToRemove.append(node)
                }
            }
        }
//        let node = map.node(atGridPosition: Point(x: 10, y: 3).vector)!
//        nodesToRemove.append(node)
        map.remove(nodesToRemove)
        
        var keys = keys
        keys.removeValue(forKey: startingPoint)
        keys.removeValue(forKey: endPoint)
        
        while !keys.isEmpty {
            let item = keys.first!
            keys.removeValue(forKey: item.key)
            let other = keys.first(where: { $0.value == item.value })!
            keys.removeValue(forKey: other.key)
            
            let node1 = map.node(atGridPosition: item.key.vector)!
            let node2 = map.node(atGridPosition: other.key.vector)!
            node1.addConnections(to: [node2], bidirectional: true)
        }
    }
    
    func findShortestRoute() -> Int {
        let startNode = map.node(atGridPosition: startingPoint.vector)!
        let endNode = map.node(atGridPosition: endPoint.vector)!
//        let startNode = map.node(atGridPosition: Point(x: 9, y: 5).vector)!
//        let endNode = map.node(atGridPosition: Point(x: 3, y: 8).vector)!
        let path = map.findPath(from: startNode, to: endNode)
        
        var mapWithPath = rawMap
        for node in path {
            if let node = node as? GKGridGraphNode {
                let point = Point(x: Int(node.gridPosition.x), y: Int(node.gridPosition.y))
                mapWithPath[point] = 3
            }
        }
//        drawMap(mapWithPath, tileMap: [0:"🟤", 1:"⚪️", 2:"⚫️", 3:"🟠", -1:"⚫️"])
        return path.count-1
    }
    
}
