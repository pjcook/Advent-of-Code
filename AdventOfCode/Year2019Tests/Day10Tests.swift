//
//  Day10Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 09/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day10Tests: XCTestCase {

    func test_part1_sample_data1() {
        
    }
    
    func test_part1_sample_data2() {
        
    }
    
    func test_part1_sample_data3() {
        
    }
    
    func test_part1() throws {
        guard let input = try readInput(filename: "Day10.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
    }
    
    func test_part2() throws {
        guard let input = try readInput(filename: "Day10.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
    }

}
