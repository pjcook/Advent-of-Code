//
//  Day10Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 09/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day10Tests: XCTestCase {

    func test_part1_sample_data1() throws {
        let input = try readInputAsStrings(filename: "Day10_sample1.input", bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, _) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(8, maxCount)
    }
    
    func test_part1_sample_data2() throws {
        let input = try readInputAsStrings(filename: "Day10_sample2.input", bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, _) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(33, maxCount)
    }
    
    func test_part1_sample_data3() throws {
        let input = try readInputAsStrings(filename: "Day10_sample3.input", bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, _) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(35, maxCount)
    }
    
    func test_part1_sample_data4() throws {
        let input = try readInputAsStrings(filename: "Day10_sample4.input", bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, _) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(41, maxCount)
    }
    
    func test_part1_sample_data5() throws {
        let input = try readInputAsStrings(filename: "Day10_sample5.input", bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, _) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(210, maxCount)
    }
        
    func test_part1() throws {
        let input = try readInputAsStrings(filename: "Day10.input", bundle: Year2019.bundle).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let (maxCount, point) = calculateBestAsteroidBaseCount(asteroidPoints)
        XCTAssertEqual(267, maxCount)
        XCTAssertEqual(Point(x: 26, y: 28), point)
    }
    
    func test_part2_sample_data1() throws {
        let input = try readInputAsStrings(filename: "Day10_part2_sample1.input", bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let points = vaporizeAsteroids(asteroidPoints, stationCoords: Point(x: 8, y: 3), mapSize: CGSize(width: 17, height: 5))
        XCTAssertEqual(Point(x: 14, y: 3), points.last)
        XCTAssertEqual(1403, points.last!.x * 100 + points.last!.y)
    }
    
    func test_part2_sample_data2() throws {
        let input = try readInputAsStrings(filename: "Day10_sample5.input", bundle: Bundle(for: Self.self)).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let points = vaporizeAsteroids(asteroidPoints, stationCoords: Point(x: 11, y: 13), mapSize: CGSize(width: 20, height: 20))
        XCTAssertEqual(Point(x: 11, y: 12), points[0])
        XCTAssertEqual(Point(x: 12, y: 1), points[1])
        XCTAssertEqual(Point(x: 12, y: 2), points[2])
        XCTAssertEqual(Point(x: 12, y: 8), points[9])
        XCTAssertEqual(Point(x: 16, y: 0), points[19])
        XCTAssertEqual(Point(x: 16, y: 9), points[49])
        XCTAssertEqual(Point(x: 10, y: 16), points[99])
        XCTAssertEqual(Point(x: 9, y: 6), points[198])
        XCTAssertEqual(Point(x: 8, y: 2), points[199])
        XCTAssertEqual(Point(x: 10, y: 9), points[200])
        XCTAssertEqual(Point(x: 11, y: 1), points[298])
    }
    
    func test_part2() throws {
        let input = try readInputAsStrings(filename: "Day10.input", bundle: Year2019.bundle).map { $0.map { String($0) } }
        let asteroidPoints = readAsteroidMap(input)
        let points = vaporizeAsteroids(asteroidPoints, stationCoords: Point(x: 26, y: 28), mapSize: CGSize(width: 34, height: 34))
        XCTAssertEqual(Point(x: 13, y: 9), points[199])
        XCTAssertEqual(1309, points[199].x * 100 + points[199].y)
    }
}
