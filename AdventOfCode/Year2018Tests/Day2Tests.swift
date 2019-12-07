//
//  Day2Tests.swift
//  Year2018Tests
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2018

class Day2Tests: XCTestCase {

    func test_part1_sample_data1() {
        let data = [
            "abcdef",
            "bababc",
            "abbcde",
            "abcccd",
            "aabcdd",
            "abcdee",
            "ababab"
        ]
        XCTAssertEqual(12, calculateChecksum(data))
    }
    
    func test_part1() throws {
        let input = try readInput(filename: "Day2.input", delimiter: "\n", cast: String.init, bundle: Year2018.bundle)
        XCTAssertEqual(6474, calculateChecksum(input))
    }
    
    func test_part2_sample_data1() {
        let data = [
            "abcde",
            "fghij",
            "klmno",
            "pqrst",
            "fguij",
            "axcye",
            "wvxyz"
        ]
        XCTAssertEqual("fgij", matchBoxIDs(data))
    }
    
    func test_part2() throws {
        let input = try readInput(filename: "Day2.input", delimiter: "\n", cast: String.init, bundle: Year2018.bundle)
        XCTAssertEqual("mxhwoglxgeauywfkztndcvjqr", matchBoxIDs(input))
    }

}
