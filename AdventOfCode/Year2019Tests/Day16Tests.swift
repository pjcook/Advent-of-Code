//
//  Day16Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 16/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day16Tests: XCTestCase {

    func test_part1_sample_data1() throws {
        let input = "12345678"
        let fft = FFT(input)
        _ = fft.resolve(phases: 4)
        let answer = fft.result(0)
        XCTAssertEqual(01029498, answer)
    }
    
    func test_part1_sample_data2() throws {
        let input = "80871224585914546619083218645595"
        let fft = FFT(input)
        _ = fft.resolve(phases: 100)
        let answer = fft.result(0)
        XCTAssertEqual(24176176, answer)
    }
    
    func test_part1_sample_data3() throws {
        let input = "19617804207202209144916044189917"
        let fft = FFT(input)
        _ = fft.resolve(phases: 100)
        let answer = fft.result(0)
        XCTAssertEqual(73745418, answer)
    }
    
    func test_part1_sample_data4() throws {
        let input = "69317163492948606335995924319873"
        let fft = FFT(input)
        _ = fft.resolve(phases: 100)
        let answer = fft.result(0)
        XCTAssertEqual(52432133, answer)
    }
    
    func test_part1() throws {
        let input = try readInput(filename: "Day16.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle)
        let fft = FFT(input[0])
        _ = fft.resolve(phases: 100)
        let answer = fft.result(0)
        XCTAssertEqual(30369587, answer)
    }
    
    func test_part2() throws {
        let input = try readInput(filename: "Day16.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle)
        var repeatedInput = ""
        for _ in 0..<10000 {
            repeatedInput += input[0]
        }
        let fft = FFT(repeatedInput)
        let result = fft.resolve(phases: 100)
        var startIndex = 0
        startIndex += result[0] * 1000000
        startIndex += result[1] * 100000
        startIndex += result[2] * 10000
        startIndex += result[3] * 1000
        startIndex += result[4] * 100
        startIndex += result[5] * 10
        startIndex += result[6]

        let answer = fft.result(startIndex)
        XCTAssertEqual(84462026, answer)
    }
    
    func test_findLastDigit() {
        let number = 1234567
        print(number - Int(number / 10 * 10))
    }
    
    func test_part2_sample_data1() throws {
        let input = "03036732577212944063491565474664"
        var repeatedInput = ""
        for _ in 0..<10000 {
            repeatedInput += input
        }
        let fft = FFT(repeatedInput)
        let result = fft.resolve(phases: 100)
        
        var startIndex = 0
        startIndex += result[0] * 1000000
        startIndex += result[1] * 100000
        startIndex += result[2] * 10000
        startIndex += result[3] * 1000
        startIndex += result[4] * 100
        startIndex += result[5] * 10
        startIndex += result[6]

        let answer = fft.result(startIndex)
        XCTAssertEqual(84462026, answer)
    }
    
    func test_multiplier() {
        let fft = FFT("")
        XCTAssertEqual(1, fft.multiplier(0, 0))
        XCTAssertEqual(0, fft.multiplier(0, 1))
        XCTAssertEqual(-1, fft.multiplier(0, 2))
        XCTAssertEqual(0, fft.multiplier(0, 3))
        
        XCTAssertEqual(0, fft.multiplier(4, 0))
        XCTAssertEqual(1, fft.multiplier(4, 4))
        XCTAssertEqual(0, fft.multiplier(4, 2))
        XCTAssertEqual(-1, fft.multiplier(4, 14))
        
        XCTAssertEqual(0, fft.multiplier(7, 0))
        XCTAssertEqual(1, fft.multiplier(7, 7))
        XCTAssertEqual(0, fft.multiplier(7, 21))
        XCTAssertEqual(-1, fft.multiplier(7, 23))
    }
}
