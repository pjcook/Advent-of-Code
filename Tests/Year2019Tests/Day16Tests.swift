//
//  Day16Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 16/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

// TODO: optimisation
class Day16Tests: XCTestCase {
    let input = try! readInputAsStrings(filename: "Day16.input", bundle: .module)

    func test_part1_sample_data1() throws {
        let input = "12345678".map { Int(String($0))! }
        let fft = FFT(input)
        _ = fft.resolve(phases: 4)
        let answer = fft.result(0)
        XCTAssertEqual(01029498, answer)
    }
    
    func test_part1_sample_data2() throws {
        let input = "80871224585914546619083218645595".map { Int(String($0))! }
        let fft = FFT(input)
        _ = fft.resolve(phases: 100)
        let answer = fft.result(0)
        XCTAssertEqual(24176176, answer)
    }
    
    func test_part1_sample_data3() throws {
        let input = "19617804207202209144916044189917".map { Int(String($0))! }
        let fft = FFT(input)
        _ = fft.resolve(phases: 100)
        let answer = fft.result(0)
        XCTAssertEqual(73745418, answer)
    }
    
    func test_part1_sample_data4() throws {
        let input = "69317163492948606335995924319873".map { Int(String($0))! }
        let fft = FFT(input)
        _ = fft.resolve(phases: 100)
        let answer = fft.result(0)
        XCTAssertEqual(52432133, answer)
    }
    
    func test_part1() {
        let fft = FFT(input[0].map { Int(String($0))! })
        _ = fft.resolve(phases: 100)
        let answer = fft.result(0)
        XCTAssertEqual(30369587, answer)
    }
    
    func test_part2() {
        var repeatedInput = ""
        for _ in 0..<10000 {
            repeatedInput += input[0]
        }
        let dropAmount = Int(String(input[0].prefix(7)))!
        let finalInput = repeatedInput.map({ Int(String($0))! }).dropFirst(dropAmount).map { $0 }
        let fft = FFT(finalInput)
        _ = fft.resolve2(phases: 100)
        let answer = fft.result(0)
        XCTAssertEqual(27683551, answer)
    }
    
    func test_part2_Daniel() {
        let string = input[0]
        let dropAmount = Int(String(string.prefix(7)))!
        let values = string
            .map { Int(String($0))! }
            .repeating(10_000)
            .flatMap { $0 }
            .dropFirst(dropAmount)
            .map { $0 }

        let answer = (1...100)
            .reduce(values) { values, _ -> [Int] in

                var total = values.reduce(0, +)
                return values.map { value in
                    defer { total -= value }
                    return total % 10
                }
            }
            .prefix(8)
            .map(String.init)
            .joined()
        XCTAssertEqual("27683551", answer)
    }
    
    func test_findLastDigit() {
        let number = 1234567
        print(abs(number - Int(number / 10 * 10)))
    }
    
    func test_part2_sample_data1() throws {
        let input = "03036732577212944063491565474664"
        var repeatedInput = ""
        for _ in 0..<10000 {
            repeatedInput += input
        }
        let dropAmount = Int(String(input.prefix(7)))!
        let finalInput = repeatedInput.map({ Int(String($0))! }).dropFirst(dropAmount).map { $0 }
        let fft = FFT(finalInput)
        _ = fft.resolve2(phases: 100)
        let answer = fft.result(0)
        XCTAssertEqual(84462026, answer)
    }
    
    func test_getResult() {
        let fft = FFT([])
        fft.output = [8,4,4,6,2,0,2,6]
        let result = fft.result(0)
        XCTAssertEqual(84462026, result)
    }
    
    func test_multiplier() {
        let fft = FFT([])
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

extension Sequence {

    /// Creates a sequence which repeats the receiver's elements.
    public func repeating() -> RepeatingSequence<Self> {
        return RepeatingSequence(base: self)
    }
}

/// A sequence which repeats the elements of a given sequence.
public struct RepeatingSequence<Base: Sequence> {
    fileprivate let base: Base
}

extension RepeatingSequence: Sequence {

    public func makeIterator() -> Iterator {
        return Iterator(base: Array(base))
    }
}

extension RepeatingSequence {

    public struct Iterator {
        private let base: [Element]
        private var pointer = 0

        fileprivate init(base: [Element]) {
            self.base = base
        }
    }
}

extension RepeatingSequence.Iterator: IteratorProtocol {

    mutating public func next() -> Base.Element? {

        defer {
            pointer += 1
            if pointer >= base.count { pointer = 0 }
        }

        return base[pointer]
    }
}

extension Collection where Element: Equatable {

    /// Finds the indices of all the elements that are equal to the given
    /// element.
    ///
    /// - Parameter elementToFind: The element to search for.
    /// - Returns: An array of indices.
    public func indices(of elementToFind: Element) -> [Index] {

        return enumerated().compactMap { (offset, element) in

            guard element == elementToFind else { return nil }

            return index(startIndex, offsetBy: offset)
        }
    }
}

extension Collection {

    /// Splits into an array of subsequences each with the given length.
    ///
    /// - Parameter length: Length of each subsequence of the returned array.
    public func split(length: Int) -> [SubSequence] {
        stride(from: 0, to: count, by: length).map {
            let lower = index(startIndex, offsetBy: $0)
            let upper = index(lower, offsetBy: length)
            return self[lower..<upper]
        }
    }
}

extension Collection {

    /// Creates a new collection containing the specified number of copies of
    /// the receiver.
    ///
    /// - Parameter count: The number of times to repeat the value passed in the
    ///                    repeating parameter. count must be zero or greater.
    public func repeating(_ count: Int) -> [Self] {
        Array(repeating: self, count: count)
    }
}
