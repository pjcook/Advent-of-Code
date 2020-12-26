//
//  Day6Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day6Tests: XCTestCase {

    func test_sample_data1() throws {
        let data = try readInputAsStrings(filename: "Day6_sample1.input", bundle: Bundle(for: Self.self))
        
        let uom = UniversalOrbitMap(data)
        XCTAssertEqual(42, uom.totalOrbits)
    }
    
    
    func test_part1() throws {
        let data = try readInputAsStrings(filename: "Day6.input", bundle: Year2019.bundle)
        
        let uom = UniversalOrbitMap(data)
        XCTAssertEqual(453028, uom.totalOrbits)
    }

    func test_part2() throws {
        let data = try readInputAsStrings(filename: "Day6.input", bundle: Year2019.bundle)
        
        let uom = UniversalOrbitMap(data)
        XCTAssertEqual(562, uom.distance(of: PlanetID.you, to: PlanetID.santa))
    }
}
