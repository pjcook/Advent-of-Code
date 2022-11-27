//
//  Day3Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 03/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day3Tests: XCTestCase {
    let input = try! readInputAsStrings(filename: "Day3.input", bundle: .module)

    func test_day3_part1() throws {
        let wireData = try input.compactMap { try WireData($0) }
        let range = wireData.reduce(WireData.DirectionRange.zero) { $0.maxRange($1.range) }
        var map = ManhattanMap(range)
        for item in wireData {
            map.plot(item)
        }
        guard let distance = map.minManhattanDistance() else {
            return XCTFail("Invalid Manhattan map")
        }
        XCTAssertEqual(232, distance)
        
        // Part 2 Answer
        XCTAssertEqual(6084, map.fewestSteps())
    }
    
    func test_sample_data_1() throws {
        let data = ["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"]
        let wireData = try data.compactMap { try WireData($0) }
        let range = wireData.reduce(WireData.DirectionRange.zero) { $0.maxRange($1.range) }
        var map = ManhattanMap(range)
        for item in wireData {
            map.plot(item)
        }
        guard let distance = map.minManhattanDistance() else {
            return XCTFail("Invalid Manhattan map")
        }
        XCTAssertEqual(159, distance)
    }
    
    func test_sample_data_2() throws {
        let data = ["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]
        let wireData = try data.compactMap { try WireData($0) }
        let range = wireData.reduce(WireData.DirectionRange.zero) { $0.maxRange($1.range) }
        var map = ManhattanMap(range)
        for item in wireData {
            map.plot(item)
        }
        guard let distance = map.minManhattanDistance() else {
            return XCTFail("Invalid Manhattan map")
        }
        XCTAssertEqual(135, distance)
    }
    
    func test_part2_sample_data_1() throws {
        let data = ["R8,U5,L5,D3", "U7,R6,D4,L4"]
        let wireData = try data.compactMap { try WireData($0) }
        let range = wireData.reduce(WireData.DirectionRange.zero) { $0.maxRange($1.range) }
        var map = ManhattanMap(range)
        for item in wireData {
            map.plot(item)
        }
        XCTAssertEqual(6, map.minManhattanDistance())
        guard let steps = map.fewestSteps() else {
            return XCTFail("Invalid Manhattan map")
        }
        XCTAssertEqual(30, steps)
    }
    
    func test_part2_sample_data_2() throws {
        let data = ["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"]
        let wireData = try data.compactMap { try WireData($0) }
        let range = wireData.reduce(WireData.DirectionRange.zero) { $0.maxRange($1.range) }
        var map = ManhattanMap(range)
        for item in wireData {
            map.plot(item)
        }
        guard let steps = map.fewestSteps() else {
            return XCTFail("Invalid Manhattan map")
        }
        XCTAssertEqual(610, steps)
    }
    
    func test_part2_sample_data_3() throws {
        let data = ["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]
        let wireData = try data.compactMap { try WireData($0) }
        let range = wireData.reduce(WireData.DirectionRange.zero) { $0.maxRange($1.range) }
        var map = ManhattanMap(range)
        for item in wireData {
            map.plot(item)
        }
        guard let steps = map.fewestSteps() else {
            return XCTFail("Invalid Manhattan map")
        }
        XCTAssertEqual(410, steps)
    }
    
    func test_directionRange_maxRange() {
        let rangeA = WireData.DirectionRange(up: 5, down: 6, left: 7, right: 8)
        let rangeB = WireData.DirectionRange(up: 10, down: 16, left: 5, right: 4)
        let combinedRange = rangeA.maxRange(rangeB)
        XCTAssertEqual(10, combinedRange.up)
        XCTAssertEqual(16, combinedRange.down)
        XCTAssertEqual(7, combinedRange.left)
        XCTAssertEqual(8, combinedRange.right)
    }
    
    func test_instruction_valid() throws {
        let instruction = try ManhattanInstruction("R123")
        XCTAssertEqual(ManhattanInstruction.Direction.R, instruction.direction)
        XCTAssertEqual(123, instruction.distance)
    }
    
    func test_instruction_invalid() throws {
        XCTAssertThrowsError(try ManhattanInstruction("X555"), "Failed") { error in
            guard let error = error as? Errors else { return XCTFail() }
            XCTAssertEqual(Errors.invalidManhattanInstruction, error)
        }
    }
    
    func test_wireData() throws {
        let wireData = try input.compactMap { try WireData($0) }
        
        XCTAssertEqual(301, wireData[0].data.count)
        XCTAssertEqual(WireData.DirectionRange(up: 5446, down: 3475, left: 1450, right: 9829), wireData[0].range)
        XCTAssertEqual(11280, wireData[0].range.maxX)
        XCTAssertEqual(8922, wireData[0].range.maxY)
        
        XCTAssertEqual(301, wireData[1].data.count)
        XCTAssertEqual(WireData.DirectionRange(up: 4290, down: 9320, left: 7024, right: 2847), wireData[1].range)
        XCTAssertEqual(9872, wireData[1].range.maxX)
        XCTAssertEqual(13611, wireData[1].range.maxY)
    }

}
