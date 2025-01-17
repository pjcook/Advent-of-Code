//
//  Day17Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day17Tests: XCTestCase {
    let input = Input("Day17.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day17()

    func test_part1() {
        XCTAssertEqual(5740, day.part1(input))
    }
    
    func test_part2() {
        var data = input
        data[0] = 2
        XCTAssertEqual(1022165, day.part2(data, program: "A,C,C,A,B,A,B,A,B,C\nR,6,R,6,R,8,L,10,L,4\nL,4,L,12,R,6,L,10\nR,6,L,10,R,8\nn\n"))
    }
}
