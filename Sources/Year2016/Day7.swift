//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public class Day7 {
    private var cache = [String: Bool]()
    
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let lists = parse(input)
        var count = 0
        
        outerLoop: for list in lists {
            var insides = [Values]()
            var outsides = [Values]()
            var isValid = false
            
            for value in list {
                switch value {
                case let .inside(v):
                    insides.append(value)
                    if isABBA(v) {
                        continue outerLoop
                    }
                    
                case .outside:
                    outsides.append(value)                    
                }
            }
            
            innerLoop: for value in outsides {
                switch value {
                case .inside:
                    continue
                    
                case let .outside(v):
                    if isABBA(v) {
                        isValid = true
                        break innerLoop
                    }
                }
            }
            
            count += isValid ? 1 : 0
        }
        
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        let lists = parse(input)
        var count = 0
        
        outerLoop: for list in lists {
            var abas = Set<String>()
            var babs = Set<String>()
            
            for value in list {
                switch value {
                case let .inside(v):
                    findBAB(v).forEach { abas.insert($0) }
                    
                case let .outside(v):
                    findABA(v).forEach { babs.insert($0) }
                }
            }
            
            let found = abas.intersection(babs).count > 0
            count += found ? 1 : 0
        }
        
        return count
    }
    
    enum Values {
        case inside(String)
        case outside(String)
    }
}

extension Day7 {
    func findABA(_ word: String) -> [String] {
        var abas = [String]()
        
        var i = 2
        while i < word.count {
            if word[i-2] == word[i] && word[i] != word[i-1] {
                abas.append(String(word[i-2] + word[i-1] + word[i]))
            }
            i += 1
        }
        
        return abas
    }
    
    func findBAB(_ word: String) -> [String] {
        var abas = [String]()
        
        var i = 2
        while i < word.count {
            if word[i-2] == word[i] && word[i] != word[i-1] {
                abas.append(String(word[i-1] + word[i-2] + word[i-1]))
            }
            i += 1
        }
        
        return abas
    }
    
    func isABBA(_ word: String) -> Bool {
        if let result = cache[word] {
            return result
        }
        
        var i = 3
        while i < word.count {
            let a = word[i-3] + word[i-2]
            let b = word[i] + word[i-1]
            if a == b && a != String(a.reversed()) {
                cache[word] = true
                return true
            }
            i += 1
        }
        
        cache[word] = false
        return false
    }
    
    func parse(_ input: [String]) -> [[Values]] {
        var results = [[Values]]()
        
        for line in input {
            var values = [Values]()
            var word = ""
            var isOutside = true
            for c in line {
                switch c {
                case "[", "]":
                    isOutside ? values.append(.outside(word)) : values.append(.inside(word))
                    word = ""
                    isOutside.toggle()
                    
                default:
                    word.append(c)
                }
            }
            isOutside ? values.append(.outside(word)) : values.append(.inside(word))
            results.append(values)
        }
        
        return results
    }
}
