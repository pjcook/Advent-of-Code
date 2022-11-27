//
//  Day23Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day23Tests: XCTestCase {
    let input = try! readInputAsIntegers(filename: "Day23.input", delimiter: ",", bundle: .module)
    
    func test_part1() {
        let network = ShipNetwork(input, numberOfComputers: 50)
        network.process()
        
        let output = network.finalOutput
        XCTAssertEqual(23886, output)
    }
    
    func test_part2() {
        let network = ShipNetwork(input, numberOfComputers: 50)
        network.isPart1 = false
        network.process()
        
        let output = network.finalOutput
        XCTAssertEqual(18333, output)
    }

}
