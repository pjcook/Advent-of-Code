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
        let array = try readInput(filename: "Day1_valid.data", delimiter: "\n", cast: Int.init, bundle: Bundle(for: InputReaderTests.self))
        XCTAssertEqual(100, array.count)
    }
    
    func test_validFile2() throws {
        let array = try readInput(filename: "Day2.input", delimiter: ",", cast: Int.init, bundle: Bundle(for: InputReaderTests.self))
        XCTAssertEqual(153, array.count)
    }
    
    func test_invalidFilename() throws {
        XCTAssertThrowsError(try readInput(filename: "nofile.data", delimiter: "\n", cast: Int.init, bundle: Bundle(for: InputReaderTests.self)), "Failed") { error in
            guard let error = error as? InputErrors else { return XCTFail() }
            XCTAssertEqual(InputErrors.invalidFilename, error)
        }
    }
    
    func test_invalidFileData() throws {
        XCTAssertThrowsError(try readInput(filename: "InvalidData.png", delimiter: "\n", cast: Int.init, bundle: Bundle(for: InputReaderTests.self)), "Failed") { error in
            guard let error = error as? InputErrors else { return XCTFail() }
            XCTAssertEqual(InputErrors.invalidFileData, error)
        }
    }
    
    func test_fileWithInvalidDataItems() throws {
        let array = try readInput(filename: "Day1_invalid.data", delimiter: "\n", cast: Int.init, bundle: Bundle(for: InputReaderTests.self))
        XCTAssertEqual(100, array.count)
    }

}
