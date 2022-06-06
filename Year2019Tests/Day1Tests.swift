//
//  Day1Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 02/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day1Tests: XCTestCase {
    let input = try! readInputAsIntegers(filename: "Day1.input", bundle: Year2019.bundle)

    func test_basicFuelCalculation() {
        XCTAssertEqual(2, basicFuelCalculation(mass: 12))
        XCTAssertEqual(2, basicFuelCalculation(mass: 14))
        XCTAssertEqual(654, basicFuelCalculation(mass: 1969))
        XCTAssertEqual(33583, basicFuelCalculation(mass: 100756))
    }
    
    func test_recursiveFuelCalculation() {
        XCTAssertEqual(2, calculateFuelRequired(mass: 14))
        XCTAssertEqual(966, calculateFuelRequired(mass: 1969))
        XCTAssertEqual(50346, calculateFuelRequired(mass: 100756))
    }
    
    func test_calculateFuelRequirement() throws {
        let sum = calculateFuelRequired(input: input)
        // XCTAssertEqual(3226822, sum) Part 1 solution
        XCTAssertEqual(4837367, sum)
    }
}
