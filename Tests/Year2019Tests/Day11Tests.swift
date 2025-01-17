//
//  Day11Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 10/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

// TODO: optimisation migrate to Computer
class Day11Tests: XCTestCase {
    let input = try! readInputAsIntegers(filename: "Day11.input", delimiter: ",", bundle: .module)
    let inputChris = try! readInputAsIntegers(filename: "Day11_chris.input", delimiter: ",", bundle: .module)

    func test_part1() throws {
        let result = paintWithRobot(input, startColor: 0)
        XCTAssertEqual(2238, result)
    }
    
    func test_part2_sample_data1() throws {
        let result = paintWithRobot(inputChris, startColor: 0)
        XCTAssertEqual(1686, result)
    }
    
    func test_part2_sample_data2() throws {
        let result = paintWithRobot(input, startColor: 1)
        XCTAssertEqual(249, result)
    }
    
    func test_part2() throws {
        let result = paintWithRobot(input, startColor: 1)
        XCTAssertEqual(249, result)
    }

}
