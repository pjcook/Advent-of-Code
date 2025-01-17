//
//  Day13Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 13/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day13Tests: XCTestCase {
    let input = Input("Day13.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day13()
    
    func test_part1() {
        XCTAssertEqual(258, day.part1(input))
    }
    
    func test_part2() {
        var data = input
        data[0] = 2
        XCTAssertEqual(12765, day.part2(data))
    }

}
