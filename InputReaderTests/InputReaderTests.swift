//
//  InputReaderTests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 02/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import InputReader

class InputReaderTests: XCTestCase {

    func test_validFile() throws {
        let array = try readInputAsIntegers(filename: "Day1_valid.input", bundle: Bundle(for: Self.self))
        XCTAssertEqual(100, array.count)
    }
    
    func test_validFile2() throws {
        let array = try readInputAsIntegers(filename: "Day2.input", delimiter: ",", bundle: Bundle(for: Self.self))
        XCTAssertEqual(153, array.count)
    }
//    
//    func test_invalidFilename() throws {
//        XCTAssertThrowsError(try readInputAsIntegers(filename: "nofile.input", bundle: Bundle(for: Self.self)), "Failed") { error in
//            guard let error = error as? InputErrors else { return XCTFail() }
//            XCTAssertEqual(InputErrors.invalidFilename, error)
//        }
//    }
//
//    func test_invalidFileData() throws {
//        XCTAssertThrowsError(try readInput(filename: "InvalidData.png", delimiter: "\n", cast: Int.init, bundle: Bundle(for: Self.self)), "Failed") { error in
//            guard let error = error as? InputErrors else { return XCTFail() }
//            XCTAssertEqual(InputErrors.invalidFileData, error)
//        }
//    }
    
    func test_fileWithInvalidDataItems() throws {
        let array = try readInputAsIntegers(filename: "Day1_invalid.input", bundle: Bundle(for: Self.self))
        XCTAssertEqual(99, array.count)
    }

}
