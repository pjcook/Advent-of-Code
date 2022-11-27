//
//  Day1Tests.swift
//  Year2018Tests
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2018

class Day1Tests: XCTestCase {
    let input = try! readInputAsIntegers(filename: "Day1.input", bundle: .module)
    
    func test_part1() throws {
        XCTAssertEqual(486, processFrequencyChanges(input))
    }
    
    func test_part2() throws {
        XCTAssertEqual(69285, findFirstDuplicateFrequency(input))
    }
    
    func test_part2_sample_data1() {
        XCTAssertEqual(0, findFirstDuplicateFrequency([+1, -1]))
    }
    
    func test_part2_sample_data2() {
        XCTAssertEqual(10, findFirstDuplicateFrequency([+3, +3, +4, -2, -4]))
    }
    func test_part2_sample_data3() {
        XCTAssertEqual(5, findFirstDuplicateFrequency([-6, +3, +8, +5, -6]))
    }
    func test_part2_sample_data4() {
        XCTAssertEqual(14, findFirstDuplicateFrequency([+7, +7, -2, -7, -4]))
    }

}
