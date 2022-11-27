//
//  Day8Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 08/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day8Tests: XCTestCase {
    let data = try! readInputAsStrings(filename: "Day8.input", bundle: .module)
    
    func test_part1_sample_data1() {
        let input = "123456789012"
        let size = CGSize(width: 3, height: 2)
        XCTAssertEqual(1, decodeImageFindMultiplier(input, size: size))
    }
    
    func test_part1() throws {
        let size = CGSize(width: 25, height: 6)
        guard let input = data.first else { throw Errors.invalidInput }
        XCTAssertEqual(1677, decodeImageFindMultiplier(input, size: size))
    }
    
    func test_part2() throws {
        let size = CGSize(width: 25, height: 6)
        guard let input = data.first else { throw Errors.invalidInput }
        renderImage(input, size: size)
    }

}
