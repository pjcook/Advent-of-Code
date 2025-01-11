//
//  Day10.swift
//  Year2019
//
//  Created by PJ COOK on 09/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import GameplayKit
import StandardLibraries

public extension Point {
    var vector: vector_int2 {
        return [Int32(x),Int32(y)]
    }
}

extension Point {
    public func addY(_ value: Int) -> Point {
        return Point(x: x, y: y + value)
    }
    
    public func addX(_ value: Int) -> Point {
        return Point(x: x + value, y: y)
    }
}

public func readAsteroidMap(_ input: [[String]]) -> [Point] {
    var asteroidPoints = [Point]()
    for y in 0..<input.count {
        for x in 0..<input[y].count {
            if input[y][x] == "#" {
                asteroidPoints.append(Point(x: x, y: y))
            }
        }
    }
    return asteroidPoints
}

public func calculateBestAsteroidBaseCount(_ asteroidPoints: [Point]) -> (Int, Point) {
    var bestAsteroid = Point.zero
    var bestCount = 0
    for asteroid in asteroidPoints {
        var count = 0
        var otherAsteroidPoints = asteroidPoints.filter { $0 != asteroid }
        while !otherAsteroidPoints.isEmpty {
            let coords = otherAsteroidPoints.removeFirst()
            let angle = asteroid.angle(to: coords)
            let otherPoints = otherAsteroidPoints.filter { asteroid.angle(to: $0) == angle }
            count += 1
            otherAsteroidPoints.removeAll { otherPoints.contains($0) }
        }
        if count > bestCount {
            bestCount = count
            bestAsteroid = asteroid
        }
    }

    return (bestCount, bestAsteroid)
}

public extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var dict = [Element: Bool]()
        return filter { dict.updateValue(true, forKey: $0) == nil }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

public func drawStarMap(size: CGSize, points: [Point], dead: [Point], station: Point) {
    var map = ""
    for y in 0..<Int(size.height) {
        var row = ""
        for x in 0..<Int(size.width) {
            let p = Point(x: x, y: y)
            if points.first(where: { $0 == p }) != nil {
                row += "🟤"
            } else if p == station {
                row += "🔆"
            } else if dead.first(where: { $0 == p }) != nil {
                row += "🔴"
            } else {
                row += "⚫️"
            }
        }
        map += row + "\n"
    }
    print(map + "\n")
}

public func vaporizeAsteroids(_ asteroidPoints: [Point], stationCoords: Point, mapSize: CGSize) -> [Point] {
    var count = 0
    var otherAsteroids = [Point:(Double, Double)]()
    var deadAsteroids = [Point]()
    let startAngle = degreesToRadians(90)
    _ = asteroidPoints.map {
        if $0 != stationCoords {
            otherAsteroids[$0] = (stationCoords.distance(to: $0), stationCoords.angle(to: $0, startAngle))
        }
    }
    let angles = otherAsteroids.map { $0.value.1 }.removingDuplicates().sorted()
//    drawStarMap(size: mapSize, points: asteroidPoints, dead: deadAsteroids, station: stationCoords)
    while !otherAsteroids.isEmpty {
        for angle in angles {
            let asteroids = otherAsteroids.filter { $0.value.1 == angle }.sorted(by: { $0.value.0 < $1.value.0 })
            if !asteroids.isEmpty, let first = asteroids.first?.key {
                otherAsteroids.removeValue(forKey: first)
                deadAsteroids.append(first)
//                drawStarMap(size: mapSize, points: otherAsteroids.map { $0.key }, dead: deadAsteroids, station: stationCoords)
                count += 1
            }
        }
    }
    
    return deadAsteroids
}
