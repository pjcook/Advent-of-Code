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

    func test_part1_sample_data1() throws {
        
    }
    
    func test_part1() throws {
        guard let data = try readInput(filename: "Day13.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { return XCTFail() }
        let output = runGame(data)
        XCTAssertEqual(258, output)
    }
    
    func test_part2_sample_data_chris() throws {
        guard var data = try readInput(filename: "Day13_chris.input", delimiter: ",", cast: Int.init, bundle: Bundle(for: Self.self)) as? [Int] else { return XCTFail() }
        data[0] = 2
        let output = playGame(data, drawBoard: false)
        XCTAssertEqual(21426, output)
    }
    
    func test_part2() throws {
        guard var data = try readInput(filename: "Day13.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { return XCTFail() }
        data[0] = 2
        let output = playGame(data)
        XCTAssertEqual(12765, output)
    }

}
