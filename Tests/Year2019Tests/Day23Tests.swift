//
//  Day23Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day23Tests: XCTestCase {
    let input = Input("Day23.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day23()
    
    func test_part1() {
        XCTAssertEqual(23886, day.part1(input, isPart1: true))
    }
    
    func test_part2() {
        XCTAssertEqual(18333, day.part1(input, isPart1: false))
    }
}
