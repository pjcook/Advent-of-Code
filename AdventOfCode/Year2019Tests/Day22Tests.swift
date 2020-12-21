//
//  Day22Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day22Tests: XCTestCase {
    let input = try! readInputAsStrings(filename: "Day22.input", bundle: Year2019.bundle)

    func test_part1() throws {
        let shuffler = DeckShuffle(sizeOfDeck: 10007)
        shuffler.process(input)
        
        var result = 0
        for i in 0..<shuffler.cards.count {
            if shuffler.cards[i] == 2019 {
                result = i
                break
            }
        }
        XCTAssertEqual(2558, result)
        print(shuffler.cards)
    }
    
    func test_part2() throws {
        // 119315717514047
        let shuffler = DeckShuffle(sizeOfDeck: 10007)
        var results = [Int:Int]()
        for _ in 0 ..< 101741582076661 {
            shuffler.process(input)
            let card = shuffler.cards[2020]
            let count = (results[card, default: 0]) + 1
            results[card] = count
            if count > 10 {
                print(card)
            }
        }
        
        XCTAssertEqual(1, shuffler.cards[2020])
    }

}
