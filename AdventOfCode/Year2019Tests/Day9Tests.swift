//
//  Day9Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 08/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day9Tests: XCTestCase {

    func test_part1_sample_data1() throws {
        let program = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
        let (result, output) = try processSensorBoost(program, input: 1)
        XCTAssertEqual(99, result)
        XCTAssertEqual(program, output)
    }
    
    func test_part1_sample_data2() throws {
        let program = [1102,34915192,34915192,7,4,7,99,0]
        let (result, _) = try processSensorBoost(program, input: 1)
        XCTAssertEqual(1219070632396864, result)
        XCTAssertEqual(16, String(result).count)
    }
    
    func test_part1_sample_data3() throws {
        let program = [104,1125899906842624,99]
        let (result, _) = try processSensorBoost(program, input: 1)
        XCTAssertEqual(1125899906842624, result)
    }
    
    func test_part1() throws {
        guard let input = try readInput(filename: "Day9.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
        let (result, output) = try processSensorBoost(input, input: 1)
        XCTAssertEqual(2377080455, result)
        XCTAssertEqual([2377080455], output)
        if !output.isEmpty { print(output) }
    }
    
    func test_part2() throws {
        guard let input = try readInput(filename: "Day9.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
        let (result, output) = try processSensorBoost(input, input: 2)
        XCTAssertEqual(74917, result)
        XCTAssertEqual([74917], output)
        if !output.isEmpty { print(output) }
    }

}
