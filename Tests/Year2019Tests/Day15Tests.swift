//
//  Day15Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 15/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import StandardLibraries
import Year2019

class Day15Tests: XCTestCase {
    let input = Input("Day15.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day15()

    func test_part1() {
//        measure {
        XCTAssertEqual(300, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(312, day.part2(input))
//        }
    }
}
