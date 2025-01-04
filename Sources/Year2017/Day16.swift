//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day16 {
    public init() {}
    
    public func part1(_ input: String, list: String) -> String {
        let operations = parse(input)
        var programs = list.map(Character.init)
        
        for op in operations {
            switch op {
            case let .spin(a):
                programs = Array(programs[(programs.count-a)...]) + Array(programs[..<(programs.count-a)])
                
            case let .exchance(a, b):
                let value = programs[a]
                programs[a] = programs[b]
                programs[b] = value
                
            case let .partner(a, b):
                let indexA = programs.firstIndex(of: a)!
                let indexB = programs.firstIndex(of: b)!
                let value = programs[indexA]
                programs[indexA] = programs[indexB]
                programs[indexB] = value
            }
        }
        
        return programs.map(String.init).joined()
    }
    
    public func part2(_ input: String, list: String, count: Int) -> String {
        let operations = parse(input)
        var programs = list.map(Character.init)
        var keys = [String]()

        for _ in 0..<count {
            let key = programs.map(String.init).joined()
            if keys.contains(key) {
                return keys[count % keys.count]
            }
            
            for op in operations {
                switch op {
                case let .spin(a):
                    programs = Array(programs[(programs.count-a)...]) + Array(programs[..<(programs.count-a)])
                    
                case let .exchance(a, b):
                    let value = programs[a]
                    programs[a] = programs[b]
                    programs[b] = value
                    
                case let .partner(a, b):
                    let indexA = programs.firstIndex(of: a)!
                    let indexB = programs.firstIndex(of: b)!
                    let value = programs[indexA]
                    programs[indexA] = programs[indexB]
                    programs[indexB] = value
                }
            }
            
            keys.append(key)
        }
        
        return programs.map(String.init).joined()
    }
    
    enum Op {
        case spin(Int)
        case exchance(Int, Int)
        case partner(Character, Character)
        
        init(_ input: String) {
            var input = input
            let value = input.removeFirst()
            
            switch value {
            case "s": self = .spin(Int(input)!)
            case "x":
                let parts = input.split(separator: "/").map(String.init).compactMap(Int.init)
                self = .exchance(parts[0], parts[1])
            case "p":
                let parts = input.split(separator: "/").map(Character.init)
                self = .partner(parts[0], parts[1])
                
            default: fatalError("Unknown op \(value)")
            }
        }
    }
}

extension Day16 {
    func parse(_ input: String) -> [Op] {
        input.split(separator: ",").map(String.init).map(Op.init)
    }
}
