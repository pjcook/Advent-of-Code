//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public final class Day11 {
    public init() {}
    
    private let validFloors = [1,2,3,4]
    private var smallest = Int.max

    public func part1(_ input: [Floor]) -> Int {
        smallest = Int.max
        var floors = [Int: Floor]()
        input.forEach { floors[$0.id] = $0 }
        let startBuilding = Building(elevator: 1, floors: Array(floors.values))
        let deviceCount = startBuilding.devices.count

        return solve(currentFloorId: 1, floors: floors, moveCount: 0, deviceCount: deviceCount)
    }
    
    public func part2(_ input: [Floor]) -> Int {
        return 1
    }
    
    public struct Building: Hashable {
        let id: String
        let elevator: Int
        let floors: [Floor]
        
        init(elevator: Int, floors: [Floor]) {
            self.elevator = elevator
            self.floors = floors
            var id = "E\(elevator)|"
            for floor in floors {
                id += "F" + String(floor.id) + floor.devices.map({ $0.key }).sorted().joined(separator: ",") + "|"
            }
            self.id = id
        }
        
        var devices: [Device] {
            var d = Set<Device>()
            for floor in floors {
                for device in floor.devices {
                    d.insert(device)
                }
            }
            return Array(d)
        }
        
        func isValid() -> Bool {
            for floor in floors {
                let microchipDevices = floor.devices(by: .microchip)
                if microchipDevices.count == floor.devices.count || microchipDevices.count == 0 {
                    continue
                }
                
                for device in microchipDevices {
                    let key = String(device.id) + DeviceType.generator.rawValue
                    if floor.devices.first(where: { $0.key == key }) == nil {
                        return false
                    }
                }
            }
            return true
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(elevator)
            for floor in floors.sorted(by: { $0.id < $1.id }) {
                hasher.combine(floor.devices.sorted(by: { $0.key < $1.key }))
            }
        }
    }
    
    public struct Floor: Hashable {
        public let id: Int
        public let devices: [Device]
        
        public init(id: Int, devices: [Device]) {
            self.id = id
            self.devices = devices
        }
        
        func devices(by type: DeviceType) -> [Device] {
            devices.filter {
                $0.type == type
            }
        }
    }
    
    public struct Device: Hashable {
        public let id: Character
        public let type: DeviceType
        public let key: String
        
        public init(id: Character, type: DeviceType) {
            self.id = id
            self.type = type
            self.key = String(id) + type.rawValue
        }
    }
    
    public enum DeviceType: String {
        case generator = "G"
        case microchip = "M"
    }
    
    struct Move {
        let currentFloorId: Int
        let floors: [Int: Floor]
        let moveCount: Int
    }
}

extension Day11 {
    func solve(currentFloorId: Int, floors: [Int: Floor], moveCount: Int, deviceCount: Int) -> Int {
        var processed = 0
        var nextMoves = [Move]()
        nextMoves.append(Move(currentFloorId: currentFloorId, floors: floors, moveCount: moveCount))
        var seen = [String: Int]()
        seen[Building(elevator: 1, floors: Array(floors.values)).id] = 0

        while !nextMoves.isEmpty {
            processed += 1
            let move = nextMoves.removeFirst()
//            if processed % 10000 == 0 {
//                print("Processing", processed, nextMoves.count, seen.count, move.moveCount)
//            }
            guard move.moveCount < smallest else { continue }
            guard !isSolved(floors: Array(move.floors.values), deviceCount: deviceCount) else {
                smallest = min(smallest, move.moveCount)
//                print("Resolved", smallest, move.moveCount, nextMoves.count)
                continue
            }
            let floors = move.floors
            let currentFloor = floors[move.currentFloorId]!
            let currentFloorId = move.currentFloorId
            let moveCount = move.moveCount
            
            for device1 in currentFloor.devices {
                var floorsToProcess = [Int]()
                if validFloors.contains(currentFloorId + 1) {
                    floorsToProcess.append(currentFloorId + 1)
                }
                if validFloors.contains(currentFloorId - 1) {
                    floorsToProcess.append(currentFloorId - 1)
                }
                
                // Try to just move single device
                for floorID in floorsToProcess {
                    let nextFloor = floors[floorID]!
                    var newFloors = floors
                    newFloors[floorID] = Floor(id: floorID, devices: ([device1] + nextFloor.devices).sorted(by: { $0.key < $1.key }))
                    newFloors[currentFloorId] = Floor(id: currentFloorId, devices: currentFloor.devices.filter({ $0.key != device1.key }).sorted(by: { $0.key < $1.key }))
                    let building = Building(elevator: floorID, floors: Array(newFloors.values))
                    let previousMoveCount = seen[building.id]
                    if (previousMoveCount == nil || previousMoveCount! > moveCount + 1) && building.isValid() {
                        seen[building.id] = moveCount + 1
                        nextMoves.append(Move(currentFloorId: floorID, floors: newFloors, moveCount: moveCount + 1))
                    } else if previousMoveCount == nil {
                        seen[building.id] = 0
                    }
                }
                
                // Try to move pairs of devices
                for device2 in currentFloor.devices where device1 != device2 {
                    for floorID in floorsToProcess {
                        let nextFloor = floors[floorID]!
                        var newFloors = floors
                        newFloors[floorID] = Floor(id: floorID, devices: [device1, device2] + nextFloor.devices)
                        newFloors[currentFloorId] = Floor(id: currentFloorId, devices: currentFloor.devices.filter({ ![device1.key, device2.key].contains($0.key) }))
                        let building = Building(elevator: floorID, floors: Array(newFloors.values))
                        let previousMoveCount = seen[building.id]
                        if (previousMoveCount == nil || previousMoveCount! > moveCount + 1) && building.isValid() {
                            seen[building.id] = moveCount + 1
                            nextMoves.append(Move(currentFloorId: floorID, floors: newFloors, moveCount: moveCount + 1))
                        } else if previousMoveCount == nil {
                            seen[building.id] = 0
                        }
                    }
                }
            }
        }

        return smallest
    }
    
    func isSolved(floors: [Floor], deviceCount: Int) -> Bool {
        floors.first(where: { $0.id == 4 })!.devices.count == deviceCount
    }
}
