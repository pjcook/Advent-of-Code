//
//  Day7Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 07/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day7Tests: XCTestCase {
    let input = Input("Day7.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day7()
    
    func test_part1() {
        XCTAssertEqual(212460, day.part1(input, settings: [0,1,2,3,4]))
    }
    
    func test_part1_example() {
        XCTAssertEqual(43210, day.part1([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0], settings: [4,3,2,1,0]))
        XCTAssertEqual(54321, day.part1([3,23,3,24,1002,24,10,24,1002,23,-1,23,
                                         101,5,23,23,1,24,23,23,4,23,99,0,0], settings: [0,1,2,3,4]))
        XCTAssertEqual(65210, day.part1([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
                                         1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0], settings: [1,0,4,3,2]))
    }
    
    func test_part2() {
        XCTAssertEqual(21844737, day.part2(input, settings: [9,8,7,6,5]))
    }
    
    func test_part2_example() {
        XCTAssertEqual(139629729, day.part2([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5], settings: [9,8,7,6,5]))
        XCTAssertEqual(18216, day.part2([3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10], settings: [9,7,8,5,6]))
    }
}
