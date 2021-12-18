import Foundation
import StandardLibraries

public struct Day18b {
    public enum Token: Equatable, CustomStringConvertible {
        case leftBracket, rightBracket
        case literal(Int)
        
        public var description: String {
            switch self {
            case .leftBracket: return "["
            case .rightBracket: return "]"
            case .literal(let value): return String(value)
            }
        }
    }
    
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let tokens = input.map(parse)
        var token = tokens[0]
        for i in (1..<tokens.count) {
            token = add(token, tokens[i])
        }
        return magnitude(token)
    }
    
    public func part2(_ input: [String]) -> Int {
        var tokens = input.map(parse)
        var answer = 0
        
        while !tokens.isEmpty {
            let token = tokens.removeLast()
            for next in tokens {
                answer = max(answer, magnitude(add(token, next)))
                answer = max(answer, magnitude(add(next, token)))
            }
        }
        
        return answer
    }
    
    public func magnitude(_ input: [Token]) -> Int {
        if input.count == 1 {
            if case let .literal(value) = input.first {
                return value
            }
            abort()
        }
        let (left, right) = constituents(input)
        return (3 * magnitude(left)) + (2 * magnitude(right))
    }
    
    func constituents(_ input: [Token]) -> ([Token],[Token]) {
        let stripped = Array(input.dropLast().dropFirst())
        
        var i = -1
        var openCount = 0
        
        while i < stripped.count {
            i += 1
            if case .leftBracket = stripped[i] { openCount += 1 }
            else if case .rightBracket = stripped[i] { openCount -= 1 }
            if openCount == 0 { break }
        }
        
        let left = Array(stripped[0..<i+1])
        let right = Array(stripped[(i+1)...])
        
        return (left,right)
    }
    
    public func add(_ left: [Token], _ right: [Token]) -> [Token] {
        reduce([.leftBracket] + left + right + [.rightBracket])
    }
    
    public func reduce(_ input: [Token]) -> [Token] {
        let exploded = explode(input)
        if exploded != input { return reduce(exploded) }
        let splitted = split(input)
        if splitted != input { return reduce(splitted) }
        return input
    }
    
    public func explode(_ input: [Token]) -> [Token] {
        var output = input
        var openCount = 0
        var i = 0
        
        while i < output.count {
            switch output[i] {
            case .leftBracket:
                openCount += 1
                
            case .rightBracket:
                openCount -= 1
                
            case .literal:
                break
            }
            
            if openCount == 5 {
                if case let .literal(value) = output[i+1] {
                    var index = i
                    while true {
                        if index < 0 { break }
                        if case let .literal(oldValue) = output[index] {
                            output[index] = .literal(value + oldValue)
                            break
                        }
                        index -= 1
                    }
                }
                
                if case let .literal(value) = output[i+2] {
                    var index = i+3
                    while true {
                        if index >= output.count { break }
                        if case let .literal(oldValue) = output[index] {
                            output[index] = .literal(value + oldValue)
                            break
                        }
                        index += 1
                    }
                }
                
                return Array(output[0..<i]) + [.literal(0)] + Array(output[(i+4)...])
            }
            
            i += 1
        }
        
        return output
    }
    
    public func split(_ input: [Token]) -> [Token] {
        for i in (0..<input.count) {
            let token = input[i]
            switch token {
            case .leftBracket, .rightBracket: break
            case .literal(let value):
                if value > 9 {
                    let (a,b) = split(value)
                    return Array(input[0..<i]) + [.leftBracket, .literal(a), .literal(b), .rightBracket] + Array(input[(i+1)...])
                }
            }
        }
        return input
    }
    
    public func split(_ value: Int) -> (Int,Int) {
        let a = value / 2
        let b = value - a
        return (a,b)
    }
    
    public func describing(_ input: [Token]) -> String {
        var output = ""
        for i in (0..<input.count-1) {
            output.append("\(input[i])")
            switch input[i] {
            case .leftBracket: break
            case .rightBracket:
                switch input[i+1] {
                case .leftBracket: output.append(",")
                case .rightBracket: break
                case .literal: output.append(",")
                }
            case .literal:
                switch input[i+1] {
                case .leftBracket: output.append(",")
                case .rightBracket: break
                case .literal: output.append(",")
                }
            }
        }
        output.append("]")
        return output
    }
    
    public func parse(_ input: String) -> [Token] {
        var basicTokens = [Token]()
        // parse input into basic tokens
        var i = 0
        var depth = 0
        while i < input.count {
            let next = input[i]
            switch next {
            case "[":
                depth += 1
                basicTokens.append(.leftBracket)
                
            case "]":
                depth -= 1
                basicTokens.append(.rightBracket)
                
            case ",":
                break
                
            default: // must be a number
                var string = String(input[i])
                for n in (i+1..<input.count) {
                    if ["[", "]", ","].contains(input[n]) {
                        let value = Int(string)!
                        basicTokens.append(.literal(value))
                        i = n - 1
                        break
                    }
                    string.append(String(input[n]))
                }
            }
            
            
            i += 1
        }
        return basicTokens
    }
}
