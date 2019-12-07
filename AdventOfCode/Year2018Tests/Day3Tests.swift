//
//  Day3Tests.swift
//  Year2018Tests
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2018

class Day3Tests: XCTestCase {

    func test_part1_sample_data1() throws {
        let input = [
            "#1 @ 1,3: 4x4",
            "#2 @ 3,1: 4x4",
            "#3 @ 5,5: 2x2"
        ]
        
        XCTAssertEqual(4, try mapClaims(input))
    }
    
    func test_part1() throws {
        let input = try readInput(filename: "Day3.input", delimiter: "\n", cast: String.init, bundle: Year2018.bundle)
        XCTAssertEqual(116491, try mapClaims(input))
    }
    
    func test_part2() throws {
        let input = try readInput(filename: "Day3.input", delimiter: "\n", cast: String.init, bundle: Year2018.bundle)
        XCTAssertEqual(707, try findUniqueClaim(input))
    }

}
