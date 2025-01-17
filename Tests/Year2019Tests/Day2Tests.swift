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
    
    let input = Input("Day2.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day2()
    
    func test_part1() {
        var values = input
        values[1] = 12
        values[2] = 2
        XCTAssertEqual(5290681, day.part1(values))
    }
    
    func test_part1_example() {
        XCTAssertEqual(3500, day.part1([1,9,10,3,2,3,11,0,99,30,40,50]))
        XCTAssertEqual(2, day.part1([1,0,0,0,9]))
        XCTAssertEqual(2, day.part1([2,3,0,3,99]))
        XCTAssertEqual(2, day.part1([2,4,4,5,99,0]))
        XCTAssertEqual(30, day.part1([1,1,1,4,99,5,6,0,99]))
    }
    
    func test_part2() {
        XCTAssertEqual(5741, day.part2(input, expectedOutput: 19690720))
    }
}
