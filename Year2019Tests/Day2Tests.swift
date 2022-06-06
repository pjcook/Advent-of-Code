//
//  Day2Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 03/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day2Tests: XCTestCase {

    func test_computer_with_no_data() throws {
        let data = [Int]()
        var computer = IntCodeComputer(data: data)
        XCTAssertThrowsError(try computer.process(), "Failed") { error in
            guard let error = error as? Errors else { return XCTFail() }
            XCTAssertEqual(error, Errors.intCodeNoData)
        }
    }
    
    func test_computer_with_invalid_data() throws {
        let data = [1,2,3]
        var computer = IntCodeComputer(data: data)
        XCTAssertThrowsError(try computer.process(), "Failed") { error in
            guard let error = error as? Errors else { return XCTFail() }
            XCTAssertEqual(error, Errors.intCodeInvalidIndex)
        }
    }
    
    func test_computer_with_valid_data() throws {
        XCTAssertEqual(3500, try IntCodeComputer.computeProgram(data: [1,9,10,3,2,3,11,0,99,30,40,50]))
        
        var computer = IntCodeComputer(data: [1,0,0,0,99])
        try computer.process()
        XCTAssertEqual(2, computer.readData[0])
        
        computer = IntCodeComputer(data: [2,3,0,3,99])
        try computer.process()
        XCTAssertEqual(2, computer.readData[0])
        XCTAssertEqual(6, computer.readData[3])
        
        computer = IntCodeComputer(data: [2,4,4,5,99,0])
        try computer.process()
        XCTAssertEqual(2, computer.readData[0])
        XCTAssertEqual(9801, computer.readData[5])
        
        computer = IntCodeComputer(data: [1,1,1,4,99,5,6,0,99])
        try computer.process()
        XCTAssertEqual(30, computer.readData[0])
    }
    
    let input = try! readInputAsIntegers(filename: "Day2.input", delimiter: ",", bundle: Year2019.bundle)
    
    func test_calculate_day2_part1_result() throws {
        var data = input
        data[1] = 12
        data[2] = 2
        XCTAssertEqual(153, data.count)
        let result = try IntCodeComputer.computeProgram(data: data)
        XCTAssertEqual(5290681, result)
    }
    
    func test_calculate_day2_part2_result() throws {
        let result = try calculateNounVerb(expectedResult: 19690720, data: input)
        XCTAssertEqual(57, result.0)
        XCTAssertEqual(41, result.1)
        XCTAssertEqual(5741, 100*result.0+result.1)
    }
}
