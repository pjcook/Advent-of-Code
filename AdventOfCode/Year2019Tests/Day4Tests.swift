//
//  Day4Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 04/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Year2019

class Day4Tests: XCTestCase {

    func test_part1() {
        let calculator = VenusPasswordCalculator()
        // Part1 XCTAssertEqual(979, calculator.howManyValidPasswordsInRange(min: 256310, max: 732736))
        XCTAssertEqual(635, calculator.howManyValidPasswordsInRange(min: 256310, max: 732736))
    }
    
    func test_sample_data1() {
        let calculator = VenusPasswordCalculator()
//        XCTAssertTrue(calculator.isValidPassword(input: 111111))
        XCTAssertTrue(calculator.isValidPassword(input: 113456))
        XCTAssertTrue(calculator.isValidPassword(input: 133456))
        XCTAssertTrue(calculator.isValidPassword(input: 123356))
        XCTAssertTrue(calculator.isValidPassword(input: 123556))
        XCTAssertTrue(calculator.isValidPassword(input: 123466))
    }
    
    func test_sample_data2() {
        let calculator = VenusPasswordCalculator()
        XCTAssertFalse(calculator.isValidPassword(input: 223450))
    }

    func test_sample_data3() {
        let calculator = VenusPasswordCalculator()
        XCTAssertFalse(calculator.isValidPassword(input: 123789))
    }
    
    func test_part2_sample_data1() {
        let calculator = VenusPasswordCalculator()
        XCTAssertTrue(calculator.isValidPassword(input: 112233))
    }
    
    func test_part2_sample_data2() {
        let calculator = VenusPasswordCalculator()
        XCTAssertFalse(calculator.isValidPassword(input: 123444))
    }
    
    func test_part2_sample_data3() {
        let calculator = VenusPasswordCalculator()
        XCTAssertTrue(calculator.isValidPassword(input: 111122))
    }
}
