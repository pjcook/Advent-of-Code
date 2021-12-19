//
//  VectorTests.swift
//  StandardLibrariesTests
//
//  Created by PJ on 12/12/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
@testable import StandardLibraries
class VectorTests: XCTestCase {

    func test_rotate() {
        let vector = Vector(x: 1, y: 0, z: 0)
        let result = vector.rotateZ()
        XCTAssertEqual(0, result.x)
        XCTAssertEqual(-1, result.y)
        XCTAssertEqual(0, result.z)
    }
    
    func test_rotate2() {
        let vector = Vector(x: 3, y: 1, z: 0)
        XCTAssertEqual(Vector(x: 1, y: -3, z: 0), vector.rotateZ())
        XCTAssertEqual(Vector(x: -3, y: -1, z: 0), vector.rotateZ().rotateZ())
        XCTAssertEqual(Vector(x: -1, y: 3, z: 0), vector.rotateZ().rotateZ().rotateZ())
        XCTAssertEqual(Vector(x: 3, y: 1, z: 0), vector.rotateZ().rotateZ().rotateZ().rotateZ())
    }
}
