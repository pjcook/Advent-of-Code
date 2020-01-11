//
//  Day15.swift
//  Year2019
//
//  Created by PJ COOK on 15/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

extension Direction {
    var moveValue: Int {
        switch self {
            case .N: return 1
            case .S: return 2
            case .W: return 3
            case .E: return 4
        }
    }
    
    var inverse: Direction {
        switch self {
        case .N: return .S
        case .S: return .N
        case .W: return .E
        case .E: return .W
        }
    }
}

extension Point {
    func directionTo(_ point: Point) -> Direction {
        if x < point.x { return .E }
        if x > point.x { return .W }
        if y > point.y { return .S }
        return .N
    }
}

enum MoveStatus: Int {
    case hitWall = 0
    case moved = 1
    case movedFoundOxygenSystem = 2
    case unknown = -1
    case start = 4
    
    var sortOrder: Int {
        switch self {
        case .unknown: return 0
        case .moved, .start: return 1
        case .movedFoundOxygenSystem: return 2
        case .hitWall: return 3
        }
    }
}

struct MapPointStatus {
    let point: Point
    let state: MoveStatus
    let options: Set<Direction>
}

class Mapper {
    private(set) var map: [Point:MapPointStatus] = [.zero:MapPointStatus(point: .zero, state: .start, options: [])]
    var computer: SteppedIntComputer?
    let tiles = [-1:"⚪️",0:"🟤", 1:"⚫️", 2:"🟠",3:"🟣",4:"🔴"]
    
    let startPosition = Point.zero
    private(set) var currentPosition = Point.zero
    private var moveValue: Direction = .E
    private var lastStatus: MoveStatus = .moved
    private var finished = false
    private var started = false
    private var route = [Direction]()
    var processEntireSpace = false
    
    init(_ input: [Int]) {
        computer = SteppedIntComputer(
            id: 1,
            data: input,
            readInput: readInput,
            processOutput: processOutput,
            completionHandler: {
                self.drawMapInConsole()
            },
            forceWriteMode: false
        )
    }
    
    func start() {
        computer?.process()
    }
    
    func createMapper() -> GKMapper {
        var newMap = [Point:Int]()
        _ = map.map {
            newMap[$0.key] = $0.value.state.rawValue
        }
        let mapper = GKMapper(newMap, wallID: 0)
        mapper.removeTilesNotIn([1,2,4])
        return mapper
    }
    
    func fillWithOxygen() -> Int {
        var isFull = false
        var minutes = 0
        while !isFull {
            fillTilesWithOxygen()
            minutes += 1
            isFull = allTilesContainOxygen()
//            drawMapInConsole()
        }
        return minutes
    }
    
    private func validOxygenNeighbours(_ point: Point) -> [Point] {
        return
            [
                point + Direction.N.point,
                point + Direction.S.point,
                point + Direction.E.point,
                point + Direction.W.point
            ]
            .compactMap { map[$0] }
            .filter { [.moved, .start].contains($0.state) }
            .map { $0.point }
    }
    
    private func fillTilesWithOxygen() {
        var tiles = [Point]()
        map
            .filter({ $0.value.state == .movedFoundOxygenSystem })
            .map { tiles += validOxygenNeighbours($0.key) }
        tiles.forEach {
            let info = map[$0]!
            map[$0] = MapPointStatus(point: $0, state: .movedFoundOxygenSystem, options: info.options)
        }
    }
    
    private func allTilesContainOxygen() -> Bool {
        return Set(map.map { $0.value.state }).count == 2
    }
    
    private func routeTo(_ point: Point) {
        let mapper = createMapper()
        var position = currentPosition
        _ = mapper.route(position, point).compactMap {
            if $0 != currentPosition {
                let direction = position.directionTo($0)
                position = position + direction.point
                route.append(direction)
            }
        }
    }
    
    private func readInput() -> Int {
        guard !finished else { return 99 }
        
        let currentTile = map[currentPosition]!
        if currentTile.options.count < 4 {
            route.removeAll()
            moveValue = Direction.all.first(where: { !currentTile.options.contains($0) })!
            return moveValue.moveValue
        }
        
        if !route.isEmpty {
            moveValue = route.removeFirst()
            return moveValue.moveValue
        }
        
        guard let tile = map.first(where: { $0.value.options.count < 4 && $0.value.state != .hitWall }) else {
            return 99
        }
        
        routeTo(tile.key)
        moveValue = route.removeFirst()
        return moveValue.moveValue
    }
    
    private func processOutput(_ value: Int) {
        lastStatus = MoveStatus(rawValue: value)!
        let currentState = map[currentPosition]!
        var options = currentState.options
        options.insert(moveValue)
        map[currentPosition] = MapPointStatus(point: currentPosition, state: currentState.state, options: options)

        let position = currentPosition + moveValue.point
        var nextOptions = map[position]?.options ?? []
        map[position] = MapPointStatus(point: position, state: lastStatus, options: nextOptions)
        
        switch lastStatus {
        case .hitWall:
            break
            
        case .moved:
            nextOptions.insert(moveValue.inverse)
            map[position] = MapPointStatus(point: position, state: lastStatus, options: nextOptions)
            currentPosition = position
            
        case .movedFoundOxygenSystem:
            nextOptions.insert(moveValue.inverse)
            map[position] = MapPointStatus(point: position, state: lastStatus, options: nextOptions)
            currentPosition = position
            if !processEntireSpace {
                finished = true
            }
            
        case .unknown, .start:
            break
        }
//        drawMapInConsole()
    }
    
    func drawMapInConsole() {
        var rawMap = [Point:Int]()
        _ = map.map { rawMap[$0] = $1.state.rawValue }
        rawMap[startPosition] = 3
        rawMap[currentPosition] = 4
        drawMapReversed(rawMap, tileMap: tiles)
    }
}

func drawMap(_ output: [Point:Int], tileMap: [Int:String], filename: String? = nil) {
    let (minX,minY,maxX,maxY) = calculateMapDimensions(output)
    var map = ""

    for y in (0...maxY-minY) {
        writeMapRow(maxX, minX, y, minY, output, tileMap, &map)
    }
    
    writeMapToFile(filename, map)
    if filename == nil { print(map + "\n") }
}

func drawMapReversed(_ output: [Point:Int], tileMap: [Int:String], filename: String? = nil) {
    let (minX,minY,maxX,maxY) = calculateMapDimensions(output)
    var map = ""

    for y in (0...maxY-minY).reversed() {
        writeMapRow(maxX, minX, y, minY, output, tileMap, &map)
    }
    
    writeMapToFile(filename, map)
    if filename == nil { print(map + "\n") }
}

func writeMapRow(_ maxX: Int, _ minX: Int, _ y: Int, _ minY: Int, _ output: [Point : Int], _ tileMap: [Int : String], _ map: inout String) {
    var row = ""
    for x in 0...maxX - minX {
        let dx = x + minX
        let dy = y + minY
        let value = output[Point(x: dx, y: dy)] ?? -1
        let char = tileMap[value] ?? "(\(value.toAscii() ?? " ")"
        row += char
    }
    map += row + "\n"
}

func writeMapToFile(_ filename: String?, _ map: String) {
    if let filename = filename {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        do {
            try map.write(to: url, atomically: true, encoding: .utf8)
            print(url)
        } catch { print(error) }
    }
}

func calculateMapDimensions(_ output: [Point:Int]) -> (Int,Int,Int,Int) {
    let minX = output.reduce(Int.max) { min($0,$1.key.x) }
    let minY = output.reduce(Int.max) { min($0,$1.key.y) }
    let maxX = output.reduce(0) { max($0,$1.key.x) }
    let maxY = output.reduce(0) { max($0,$1.key.y) }
    return (minX,minY,maxX,maxY)
}
