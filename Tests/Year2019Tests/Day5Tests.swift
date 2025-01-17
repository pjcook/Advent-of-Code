//
//  Day5Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 05/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day5Tests: XCTestCase {
    let input = Input("Day5.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day5()
    
    func test_part1() {
        XCTAssertEqual(9006673, day.part1(input, code: 1))
    }
    
    func test_part2() {
        XCTAssertEqual(3629692, day.part1(input, code: 5))
    }
}
