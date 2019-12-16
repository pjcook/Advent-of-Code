//
//  Day15Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 15/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day15Tests: XCTestCase {

    func test_part1() throws {
        guard let input = try readInput(filename: "Day11.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
        let mapper = Mapper(input + Array(repeating: 0, count: 2000))
        mapper.start()
    }

}
