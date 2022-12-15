//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day15 {
    public init() {}
    
    let beaconChar = "B"
    let sensorChar = "S"
    let airChar = "."
    let noBeacon = "#"
    
    public func part1(_ input: [String], rowToCheck: Int) -> Int {
        let pairs = parse(input)
        var points = [Point: String]()
        var minX = 0
        var maxX = 0
        
        for pair in pairs {
            let sensor = pair.0
            let beacon = pair.1
            
            // for any space within manhattan from sensor to beacon make `noBeacon`
            let distance = sensor.manhattanDistance(to: beacon)
            let range = ((sensor.y - distance)..<(sensor.y + distance))
            guard range.contains(rowToCheck) else { continue}
            for x in ((sensor.x - distance)..<(sensor.x + distance)) {
                if x < minX {
                    minX = x
                }
                if x > maxX {
                    maxX = x
                }
                let point = Point(x,rowToCheck)
                if sensor.manhattanDistance(to: point) <= distance {
                    points[point] = noBeacon
                }
            }
        }
        
        for pair in pairs {
            let sensor = pair.0
            let beacon = pair.1
            points[sensor] = sensorChar
            points[beacon] = beaconChar
        }
        
        return points.reduce(0, { $0 + ($1.value == noBeacon ? 1 : 0) })
    }
    
    public func part2(_ input: [String], upperBound: Int) -> Int {
        let pairs = parse(input)
        let sensorData = pairs.map { SensorData(sensor: $0, beacon: $1) }
                
        for y in (0..<upperBound) {
            var ranges = sensorData.filter({ $0.isInRange(for: y) }).map({ $0.range(for: y) })
            var range = ranges.removeFirst()
            while !ranges.isEmpty {
                if let nextRange = ranges.first(where: { ((range.lowerBound-1)...(range.upperBound+1)).overlaps($0) }) {
                    ranges.remove(at: ranges.firstIndex(of: nextRange)!)
                    range = (min(range.lowerBound, nextRange.lowerBound)...max(range.upperBound, nextRange.upperBound))
                } else {
                    if ranges.first(where: { ((range.lowerBound)...(range.upperBound+2)).overlaps($0) }) != nil {
                        let x = range.upperBound + 1
                        return x * 4_000_000 + y
                    } else {
                        let x = range.lowerBound - 1
                        return x * 4_000_000 + y
                    }
                }
            }
        }
        
        return -1
    }
}

extension Day15 {
    public struct SensorData {
        public let sensor: Point
        public let beacon: Point
        public let manhattanDistance: Int
        public let minY: Int
        public let maxY: Int
        
        public init(sensor: Point, beacon: Point) {
            self.sensor = sensor
            self.beacon = beacon
            self.manhattanDistance = sensor.manhattanDistance(to: beacon)
            self.minY = sensor.y - manhattanDistance
            self.maxY = sensor.y + manhattanDistance
        }
        
        public func isInRange(for y: Int) -> Bool {
            (minY..<maxY).contains(y)
        }
        
        public func range(for y: Int) -> ClosedRange<Int> {
            let distance = manhattanDistance - abs(sensor.y - y)
            return ((sensor.x - distance)...(sensor.x + distance))
        }
    }
    
    public func parse(_ input: [String]) -> [(Point, Point)] {
        var output = [(Point, Point)]()
        
        for line in input {
            let components = line.components(separatedBy: " ")
            let x1 = Int(components[2].replacingOccurrences(of: "x=", with: "").replacingOccurrences(of: ",", with: ""))!
            let y1 = Int(components[3].replacingOccurrences(of: "y=", with: "").replacingOccurrences(of: ":", with: ""))!
            let x2 = Int(components[8].replacingOccurrences(of: "x=", with: "").replacingOccurrences(of: ",", with: ""))!
            let y2 = Int(components[9].replacingOccurrences(of: "y=", with: ""))!
            output.append((Point(x1, y1), Point(x2, y2)))
        }
        
        return output
    }
}
