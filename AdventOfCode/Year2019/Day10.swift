//
//  Day10.swift
//  Year2019
//
//  Created by PJ COOK on 09/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

extension CGPoint: Hashable {
    func angle(to point: CGPoint, _ startAngle: Double = 0) -> Double {
        let dx = point.x - x
        let dy = point.y - y
        let angle = Double(atan2f(Float(dy), Float(dx))) + startAngle
        if angle < 0 { return angle + degreesToRadians(360) }
        return angle
    }
    
    func distance(to point: CGPoint) -> Float {
        let dx = point.x - x
        let dy = point.y - y
        return Float(sqrt(dx * dx + dy * dy))
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

func radiansToDegrees(_ number: Double) -> Double {
    return number * 180 / .pi
}

func degreesToRadians(_ number: Double) -> Double {
    return number * .pi / 180
}

func readAsteroidMap(_ input: [[String]]) -> [CGPoint] {
    var asteroidPoints = [CGPoint]()
    for y in 0..<input.count {
        for x in 0..<input[y].count {
            if input[y][x] == "#" {
                asteroidPoints.append(CGPoint(x: x, y: y))
            }
        }
    }
    return asteroidPoints
}

func calculateBestAsteroidBaseCount(_ asteroidPoints: [CGPoint]) -> (Int, CGPoint) {
    var bestAsteroid = CGPoint.zero
    var bestCount = 0
    for asteroid in asteroidPoints {
        var count = 0
        var otherAsteroidPoints = asteroidPoints.filter { $0 != asteroid }
        while !otherAsteroidPoints.isEmpty {
            let coords = otherAsteroidPoints.removeFirst()
            let angle = asteroid.angle(to: coords)
            let otherCGPoints = otherAsteroidPoints.filter { asteroid.angle(to: $0) == angle }
            count += 1
            otherAsteroidPoints.removeAll { otherCGPoints.contains($0) }
        }
        if count > bestCount {
            bestCount = count
            bestAsteroid = asteroid
        }
    }

    return (bestCount, bestAsteroid)
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var dict = [Element: Bool]()
        return filter { dict.updateValue(true, forKey: $0) == nil }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

func drawStarMap(size: CGSize, points: [CGPoint], dead: [CGPoint], station: CGPoint) {
    var map = ""
    for y in 0..<Int(size.height) {
        var row = ""
        for x in 0..<Int(size.width) {
            let p = CGPoint(x: x, y: y)
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

func vaporizeAsteroids(_ asteroidPoints: [CGPoint], stationCoords: CGPoint, mapSize: CGSize) -> [CGPoint] {
    var count = 0
    var otherAsteroids = [CGPoint:(Float, Double)]()
    var deadAsteroids = [CGPoint]()
    let startAngle = degreesToRadians(90.1)
    _ = asteroidPoints.map {
        if $0 != stationCoords {
            otherAsteroids[$0] = (stationCoords.distance(to: $0), stationCoords.angle(to: $0, startAngle))
        }
    }
    let angles = otherAsteroids.map { $0.value.1 }.removingDuplicates().sorted()
    drawStarMap(size: mapSize, points: asteroidPoints, dead: deadAsteroids, station: stationCoords)
    while !otherAsteroids.isEmpty {
        for angle in angles {
            let asteroids = otherAsteroids.filter { $0.value.1 == angle }.sorted(by: { $0.value.0 < $1.value.0 })
            if !asteroids.isEmpty, let first = asteroids.first?.key {
                otherAsteroids.removeValue(forKey: first)
                deadAsteroids.append(first)
                drawStarMap(size: mapSize, points: otherAsteroids.map { $0.key }, dead: deadAsteroids, station: stationCoords)
                count += 1
            }
        }
    }
    
    return deadAsteroids
}
