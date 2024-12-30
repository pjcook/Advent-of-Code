//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day4 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var count = 0
        
        for line in input {
            let (components, sectorID, checksum) = parse(line)
            var chars = [Character: Int]()
            for component in components {
                for c in component {
                    chars[c] = chars[c, default: 0] + 1
                }
            }
            if chars
                .sorted(by: {
                    if $0.value == $1.value {
                        return $0.key < $1.key
                    }
                    return $0.value > $1.value
                })
                .prefix(5)
                .map(\.key)
                .sorted()
                .map(String.init)
                .joined() == checksum.sorted().map(String.init).joined() {
                count += sectorID
            }
        }
        
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        for line in input {
            if decrypt(line) == "northpole object storage" {
                let (_, sectorID, _) = parse(line)
                return sectorID
            }
        }
        
        return -1
    }
    
    public func decrypt(_ input: String) -> String {
        let (components, sectorID, _) = parse(input)
        let m = sectorID % 26
        
        var words = [String]()
        
        for component in components {
            var word = ""
            for c in component {
                let index =  (Alphabet.lettersList.firstIndex(of: c)! + m) % 26
                word.append(Alphabet.lettersList[index])
            }
            words.append(word)
        }
        
        print(words.joined(separator: " "))
        return words.joined(separator: " ")
    }
    
    public func parse(_ input: String) -> ([String], Int, String) {
        let parts = input.replacingOccurrences(of: "]", with: "").split(separator: "[")
        let checksum = String(parts[1])
        var components = parts[0].split(separator: "-")
        let sectorID = Int(String(components.removeLast()))!
        return (components.map(String.init), sectorID, checksum)
    }
}
