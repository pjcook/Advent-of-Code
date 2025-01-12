//
//  Day15Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 15/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import StandardLibraries
import Year2019

// TODO: optimisation
class Day15Tests: XCTestCase {
    let input = try! readInputAsIntegers(filename: "Day15.input", delimiter: ",", bundle: .module)

    func test_part1() throws {
        let mapper = Mapper(input + Array(repeating: 0, count: 2000))
        mapper.start()
        
        let router = mapper.createMapper()
        let endPoint = mapper.map.first { $0.value.state == .movedFoundOxygenSystem }!
        let path = router.route(mapper.startPosition, endPoint.key)
        let distance = path.count - 1
        XCTAssertEqual(Point(x: 18, y: -18), endPoint.key)
        XCTAssertEqual(300, distance)
    }
    
    func test_part2() throws {
        let mapper = Mapper(input + Array(repeating: 0, count: 2000))
        mapper.processEntireSpace = true
        mapper.start()
        
        let minutes = mapper.fillWithOxygen()
        XCTAssertEqual(312, minutes)
    }

}
