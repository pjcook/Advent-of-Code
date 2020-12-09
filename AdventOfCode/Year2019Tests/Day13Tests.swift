//
//  Day13Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 13/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day13Tests: XCTestCase {
    let data = try! readInputAsIntegers(filename: "Day13.input", delimiter: ",", bundle: Year2019.bundle)

    func test_part1_sample_data1() throws {
        
    }
    
    func test_part1() {
        let output = runGame(data)
        XCTAssertEqual(258, output)
    }
    
    func test_part2_sample_data_chris() throws {
        var data = try readInputAsIntegers(filename: "Day13_chris.input", delimiter: ",", bundle: Bundle(for: Self.self))
        data[0] = 2
        let output = playGame(data, drawBoard: false)
        XCTAssertEqual(21426, output)
    }
    
    func test_part2() {
        var data = self.data
        data[0] = 2
        let output = playGame(data)
        XCTAssertEqual(12765, output)
    }

}
