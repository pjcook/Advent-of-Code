//
//  DirectionTests.swift
//  StandardLibrariesTests
//
//  Created by PJ on 12/12/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import StandardLibraries
class DirectionTests: XCTestCase {

    func test_rotateWithTimes() {
        let direction = CompassDirection.e
    
        // RIGHT
        XCTAssertEqual(.e, direction.rotateRight(times: 0))
        XCTAssertEqual(.s, direction.rotateRight(times: 1))
        XCTAssertEqual(.w, direction.rotateRight(times: 2))
        XCTAssertEqual(.n, direction.rotateRight(times: 3))
        XCTAssertEqual(.e, direction.rotateRight(times: 4))
        XCTAssertEqual(.s, direction.rotateRight(times: 5))
        
        // LEFT
        XCTAssertEqual(.e, direction.rotateLeft(times: 0))
        XCTAssertEqual(.n, direction.rotateLeft(times: 1))
        XCTAssertEqual(.w, direction.rotateLeft(times: 2))
        XCTAssertEqual(.s, direction.rotateLeft(times: 3))
        XCTAssertEqual(.e, direction.rotateLeft(times: 4))
        XCTAssertEqual(.n, direction.rotateLeft(times: 5))
    }
    
}
