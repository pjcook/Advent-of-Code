//
//  Day11Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 10/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day11Tests: XCTestCase {

    func test_part1() throws {
        guard let input = try readInput(filename: "Day11.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
        let result = paintWithRobot(input, startColor: 0)
        XCTAssertEqual(2238, result)
    }
    
    func test_part2_sample_data1() throws {
        guard let input = try readInput(filename: "Day11_chris.input", delimiter: ",", cast: Int.init, bundle: Bundle(for: Self.self)) as? [Int] else { throw Errors.invalidInput }
        let result = paintWithRobot(input, startColor: 0)
        XCTAssertEqual(1686, result)
    }
    
    func test_part2_sample_data2() throws {
        guard let input = try readInput(filename: "Day11_chris.input", delimiter: ",", cast: Int.init, bundle: Bundle(for: Self.self)) as? [Int] else { throw Errors.invalidInput }
        let result = paintWithRobot(input, startColor: 1)
        XCTAssertEqual(249, result)
    }
    
    func test_part2() throws {
        guard let input = try readInput(filename: "Day11.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
        let result = paintWithRobot(input, startColor: 1)
        XCTAssertEqual(249, result)
    }

}
