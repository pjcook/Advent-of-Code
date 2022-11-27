//
//  Day19.swift
//  Year2019Tests
//
//  Created by PJ COOK on 18/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day19Tests: XCTestCase {
    let input = try! readInputAsIntegers(filename: "Day19.input", delimiter: ",", bundle: .module)
    
    func test_part1() {
        let computer = TractorBeamAnalyser(input: input, size: GridSize(width: 50, height: 50))
        let result = computer.calculate()
        XCTAssertEqual(206, result)
    }
    
    func test_part2() {
        let computer = TractorBeamAnalyser(input: input, size: GridSize(width: 100000, height: 100000))
        let result = computer.findTractorDistance(GridSize(width: 99, height: 99), startPosition: Point(x: 0, y: 5))
        XCTAssertEqual(6190948, result)
    }
    
    func test_part2_sample() {
        let computer = TractorBeamAnalyser(input: input, size: GridSize(width: 10000, height: 10000))
        let size = GridSize(width: 100, height: 100)
        let tl = Point(x: 625, y: 957)
        let tr = tl.addX(size.width)
        let bl = tl.addY(size.height)
        let br = tl.addX(size.width).addY(size.height)
        
        XCTAssertEqual(1, computer.checkPosition(tl))
        XCTAssertEqual(1, computer.checkPosition(tr))
        XCTAssertEqual(1, computer.checkPosition(bl))
        XCTAssertEqual(1, computer.checkPosition(br))
    }

}
