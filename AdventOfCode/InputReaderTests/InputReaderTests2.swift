//
//  InputReaderTests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 02/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import InputReader

class InputReaderTests2: XCTestCase {

    func test_validFile() throws {
        let input = try Input("Day1_valid.input", Bundle(for: Self.self))
        let array = input.lines.compactMap(Int.init)
        XCTAssertEqual(100, array.count)
    }
    
    func test_validFile2() throws {
        let input = try Input("Day2.input", Bundle(for: Self.self))
        let array = input.delimited(",", cast: Int.init)
        XCTAssertEqual(153, array.count)
    }
    
    func test_invalidFilename() throws {
        XCTAssertThrowsError(try Input("nofile.input", Bundle(for: Self.self)), "Failed") { error in
            guard let error = error as? InputErrors else { return XCTFail() }
            XCTAssertEqual(InputErrors.invalidFilename, error)
        }
    }
    
    func test_fileWithInvalidDataItems() throws {
        let input = try Input("Day1_invalid.input", Bundle(for: Self.self))
        let array = input.lines.compactMap(Int.init)
        XCTAssertEqual(99, array.count)
    }

}
