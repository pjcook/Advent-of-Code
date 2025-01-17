//
//  Day19.swift
//  Year2019Tests
//
//  Created by PJ COOK on 18/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import StandardLibraries
import Year2019

class Day19Tests: XCTestCase {
    let input = try! readInputAsIntegers(filename: "Day19.input", delimiter: ",", bundle: .module)
    let day = Day19()
    
    func test_part1() {
        XCTAssertEqual(206, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(6190948, day.part2(input))
    }
}
