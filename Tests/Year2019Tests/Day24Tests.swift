//
//  Day24Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day24Tests: XCTestCase {

    func test_part1() {
        let result = day24Part1()
        XCTAssertEqual(28717468, result)
    }
    
    func test_part2_sample1() {
        let bugGrid = BugGrid()
        bugGrid.sample1()

        let result = day24Part2(bugGrid: bugGrid, iterations: 10)
        XCTAssertEqual(99, result)
    }
    
    func test_part2() {
        let bugGrid = BugGrid()
        bugGrid.initialise()
        
        let result = day24Part2(bugGrid: bugGrid, iterations: 200)
        XCTAssertEqual(2014, result)
    }

}
