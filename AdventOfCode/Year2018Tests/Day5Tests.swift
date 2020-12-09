//
//  Day5Tests.swift
//  Year2018Tests
//
//  Created by PJ on 06/12/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2018

class Day5Tests: XCTestCase {
    let input = Input("Day5.input", Year2018.bundle)
    
    func test_part1() {
        let day = Day5()
        XCTAssertEqual(11636, day.part1(input: input.input).count)
    }
    
    func test_part2() {
        let filters = "abcdefghijklmnopqrstuvwxyz"
        let day = Day5()
        var min = 11636
        
        for filter in filters {
            
            let filteredInput = input.input.replacingOccurrences(of: String(filter), with: "", options: .caseInsensitive)
            let count = day.part1(input: filteredInput).count
            if count < min {
                min = count
            }
        }
        
        XCTAssertEqual(5302, min)
    }
    
    func test_part1_daniel() {
        let day = Day5()
        XCTAssertEqual(11636, day.part1_daniel(input: input.input))
    }
    
    func test_part2_daniel() {
        let day = Day5()
        XCTAssertEqual(5302, day.part2_daniel(input: input.input))
    }
    
    func test_part1_react() {
        let day = Day5()
        XCTAssertFalse(day.react(a: nil, b: "a"))
        XCTAssertFalse(day.react(a: "a", b: "a"))
        XCTAssertFalse(day.react(a: "A", b: "A"))
        XCTAssertTrue(day.react(a: "a", b: "A"))
    }
}
