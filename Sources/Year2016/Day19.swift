//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day19 {
    public init() {}
    
    public func part1(_ input: Int) -> Int {
        let firstElf = Elf(id: 1)
        var elf = firstElf
        var i = 2
        while i <= input {
            let newElf = Elf(id: i)
            elf.next = newElf
            newElf.previous = elf
            elf = newElf
            i += 1
        }
        elf.next = firstElf
        firstElf.previous = elf
        elf = firstElf

        while elf.next != nil {
            elf = elf.tick()
        }
        return elf.id
    }
    
    final class Elf {
        let id: Int
        var next: Elf?
        var previous: Elf?
        
        init(id: Int) {
            self.id = id
        }
        
        func tick() -> Elf {
            guard let stoleFrom = next else { return self }
            stoleFrom.previous = nil
            self.next = stoleFrom.next
            stoleFrom.next = nil
            guard let next else { return self }
            next.previous = self
            return next
        }
        
        func remove() {
            self.previous?.next = self.next
            self.next?.previous = self.previous
            self.next = nil
            self.previous = nil
        }
    }
    
    public func part2(_ input: Int) -> Int {
        let firstElf = Elf(id: 1)
        var elf = firstElf
        var i = 2
        while i <= input {
            let newElf = Elf(id: i)
            elf.next = newElf
            newElf.previous = elf
            elf = newElf
            i += 1
        }
        elf.next = firstElf
        firstElf.previous = elf
        elf = firstElf
        
        var elfCount = input
        var opposite = find(elf: elf, distance: elfCount / 2)

        while elf.next != nil {
            var nextOpposite = opposite?.next
            if elfCount.isOdd {
                nextOpposite = nextOpposite?.next
            }
            opposite?.remove()
            opposite = nextOpposite
            
            if let next = elf.next {
                elf = next
            }
            elfCount -= 1
        }
        return elf.id
    }
    
    func find(elf: Elf, distance: Int) -> Elf? {
        var elf = elf
        for _ in 0..<distance {
            guard let next = elf.next else { break }
            elf = next
        }
        return elf
    }
}
