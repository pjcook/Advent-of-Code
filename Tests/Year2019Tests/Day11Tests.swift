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

class Day11Tests: XCTestCase {
    let input = Input("Day11.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day11()

    func test_part1() throws {
        XCTAssertEqual(2238, day.part1(input))
    }
    
    func test_part2() throws {
        XCTAssertEqual(249, day.part2(input))
    }
}
