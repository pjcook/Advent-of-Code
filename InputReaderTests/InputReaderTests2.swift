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
    
    func test_validFile() {
        let input = Input("Day1_valid.input", Bundle(for: Self.self))
        let array = input.lines.compactMap(Int.init)
        XCTAssertEqual(100, array.count)
    }
    
    func test_validFile2() {
        let input = Input("Day2.input", Bundle(for: Self.self))
        let array = input.delimited(",", cast: Int.init)
        XCTAssertEqual(153, array.count)
    }
    
    func test_validFile2_withExtension() {
        let input = Input("Day2", with: "input", Bundle(for: Self.self))
        let array = input.delimited(",", cast: Int.init)
        XCTAssertEqual(153, array.count)
    }
    
    //    func test_invalidFilename() throws {
    //        XCTAssertThrowsError(try Input("nofile.input", Bundle(for: Self.self)), "Failed") { error in
    //            guard let error = error as? InputErrors else { return XCTFail() }
    //            XCTAssertEqual(InputErrors.invalidFilename, error)
    //        }
    //    }
    
    func test_fileWithInvalidDataItems() {
        let input = Input("Day1_invalid.input", Bundle(for: Self.self))
        XCTAssertEqual(99, input.integers.count)
    }
    
    func test_fileWithInvalidDataItems_qfile() throws {
        let filename = "Day1_valid.input"
        let bundle = Bundle(for: Self.self)
        let url = bundle.url(forResource: filename, withExtension: nil)!
        let file = QFile(fileURL: url)
        try file.open()
        var input = [Int]()
        while let line = try file.readLine() {
            let clean = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if !clean.isEmpty {
                input.append(Int(clean)!)
            }
        }
        file.close()
        XCTAssertEqual(100, input.count)
    }
}
