//
//  Day9Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 08/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day9Tests: XCTestCase {
    let input = Input("Day9.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day9()
    
    func test_part1() {
        XCTAssertEqual(2377080455, day.part1(input, code: 1))
    }
    
    func test_part2() {
        XCTAssertEqual(74917, day.part1(input, code: 2))
    }
}
