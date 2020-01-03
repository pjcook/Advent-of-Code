//
//  Day23Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day23Tests: XCTestCase {

    func test_part1() throws {
        guard let input = try readInput(filename: "Day23.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
        
        let network = ShipNetwork(input, numberOfComputers: 50)
        network.process()
        
        let output = network.finalOutput
        XCTAssertEqual(23886, output)
    }
    
    func test_part2() throws {
        guard let input = try readInput(filename: "Day23.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
        
        let network = ShipNetwork(input, numberOfComputers: 50)
        network.isPart1 = false
        network.process()
        
        let output = network.finalOutput
        XCTAssertEqual(18333, output)
    }

}
