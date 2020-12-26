//
//  Day22Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day22Tests: XCTestCase {
    let input = try! readInputAsStrings(filename: "Day22.input", bundle: Year2019.bundle)

    func test_part1() throws {
        let shuffler = DeckShuffle(sizeOfDeck: 10007)
        XCTAssertEqual(2558, shuffler.process(input))
    }
    
    func test_part2() throws {
        let shuffler = DeckShuffle(sizeOfDeck: 119_315_717_514_047)
        XCTAssertEqual(66036767136129, shuffler.process(input))
    }
}
