//
//  Day22.swift
//  Year2019
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import Foundation

class DeckShuffle {
    private let sizeOfDeck: Int
    private(set) var cards: [Int]
    
    init(sizeOfDeck: Int) {
        self.sizeOfDeck = sizeOfDeck
//        var array = [Int]()
//        for i in 0..<sizeOfDeck {
//            array.append(i)
//        }
//        cards = array
        cards = Array(0..<sizeOfDeck)
    }
    
    func process(_ input: [String]) {
        for line in input {
//            print(line)
            if line == "deal into new stack" {
                cards = deal(cards)
            } else if line.hasPrefix("cut") {
                let split = line.split(separator: " ")
                let cutValue = Int(String(split.last!))!
                if cutValue > 0 {
                    cards = cut(cards, cut: cutValue)
                } else {
                    cards = cutNegative(cards, cut: cutValue)
                }
            } else {
                let split = line.split(separator: " ")
                let value = Int(String(split.last!))!
                cards = increment(cards, n: value)
            }
        }
    }
    
    func deal(_ items: [Int]) -> [Int] {
        return items.reversed()
    }

    func cut(_ items: [Int], cut: Int) -> [Int] {
        var items = items
        let partItems = items[..<cut]
        items.removeFirst(cut)
        return items + partItems
    }

    func cutNegative(_ items: [Int], cut: Int) -> [Int] {
        var items = items
        let index = items.count+cut
        let partItems = items[index...]
        items.removeLast(abs(cut))
        return partItems + items
    }

    func increment(_ items: [Int], n: Int) -> [Int] {
        var array = Array(repeating: -1, count: items.count)
        var pointer = 0
        for i in items {
            array[pointer] = i
            pointer += n
            if pointer >= items.count {
                pointer = pointer - items.count
            }
        }
        
        return array
    }
}




