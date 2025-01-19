//
//  Day21Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day21Tests: XCTestCase {
    let input = Input("Day21.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day21()
    
    func test_part1() {
        let program = """
        NOT A J
        NOT B T
        OR T J
        NOT C T
        OR T J
        AND D J
        WALK

        """
        XCTAssertEqual(19352638, day.part1(input, springScriptProgram: program))
    }
    
    func test_part2() {
        let program = """
        NOT A J
        NOT B T
        OR T J
        NOT C T
        OR T J
        AND D J
        OR J T
        AND E T
        OR H T
        AND D T
        AND T J
        RUN
        
        """
        XCTAssertEqual(1141251258, day.part1(input, springScriptProgram: program))
    }
}
