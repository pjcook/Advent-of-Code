//
//  Day22Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day22Tests: XCTestCase {
    let input = try! readInputAsStrings(filename: "Day22.input", bundle: Year2019.bundle)

    func test_part1() throws {
        let day = Day22()
        XCTAssertEqual(2558, day.part1(input))
    }
    
    func test_part2() throws {
        let day = Day22()
        XCTAssertEqual(63967243502561, day.part2(input))
    }
}
