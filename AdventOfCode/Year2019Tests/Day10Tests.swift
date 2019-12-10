//
//  Day10Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 09/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day10Tests: XCTestCase {

    func test_part1_sample_data1() throws {
        let input = try readInput(filename: "Day10_sample1.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, _) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(8, maxCount)
    }
    
    func test_part1_sample_data2() throws {
        let input = try readInput(filename: "Day10_sample2.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, _) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(33, maxCount)
    }
    
    func test_part1_sample_data3() throws {
        let input = try readInput(filename: "Day10_sample3.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, _) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(35, maxCount)
    }
    
    func test_part1_sample_data4() throws {
        let input = try readInput(filename: "Day10_sample4.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, _) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(41, maxCount)
    }
    
    func test_part1_sample_data5() throws {
        let input = try readInput(filename: "Day10_sample5.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, _) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(210, maxCount)
    }
        
    func test_part1() throws {
        let input = try readInput(filename: "Day10.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, point) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(267, maxCount)
        XCTAssertEqual(CGPoint(x: 26, y: 28), point)
    }
    
    func test_part2_sample_data1() throws {
        let input = try readInput(filename: "Day10_part2_sample1.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let points = vaporizeAsteroids(asteroidPoints, stationCoords: CGPoint(x: 8, y: 3), mapSize: CGSize(width: 17, height: 5))
        XCTAssertEqual(CGPoint(x: 14, y: 3), points[asteroidPoints.count-1])
        XCTAssertEqual(1403, points[asteroidPoints.count-1].x * 100 + points[asteroidPoints.count-1].y)
    }
    
    func test_part2_sample_data2() throws {
        let input = try readInput(filename: "Day10_sample5.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let points = vaporizeAsteroids(asteroidPoints, stationCoords: CGPoint(x: 11, y: 13), mapSize: CGSize(width: 20, height: 20))
        XCTAssertEqual(CGPoint(x: 11, y: 12), points[0])
        XCTAssertEqual(CGPoint(x: 12, y: 1), points[1])
        XCTAssertEqual(CGPoint(x: 12, y: 2), points[2])
        XCTAssertEqual(CGPoint(x: 12, y: 8), points[9])
        XCTAssertEqual(CGPoint(x: 16, y: 0), points[19])
        XCTAssertEqual(CGPoint(x: 16, y: 9), points[49])
        XCTAssertEqual(CGPoint(x: 10, y: 16), points[99])
        XCTAssertEqual(CGPoint(x: 9, y: 6), points[198])
        XCTAssertEqual(CGPoint(x: 8, y: 2), points[199])
        XCTAssertEqual(CGPoint(x: 10, y: 9), points[200])
        XCTAssertEqual(CGPoint(x: 11, y: 1), points[298])
    }
    
    func test_part2() throws {
        let input = try readInput(filename: "Day10.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let points = vaporizeAsteroids(asteroidPoints, stationCoords: CGPoint(x: 26, y: 28), mapSize: CGSize(width: 34, height: 34))
        XCTAssertEqual(CGPoint(x: 22, y: 3), points[200])
        XCTAssertEqual(2203, points[200].x * 100 + points[200].y)
    }
}
