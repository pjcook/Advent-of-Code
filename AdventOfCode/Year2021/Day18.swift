import Foundation
import StandardLibraries

public protocol Token {
    var id: UUID { get }
    var parent: Token? { get set }
    var depth: Int { get }
    func addToLeft(_ value: Int, cameFrom: Token)
    func addToRight(_ value: Int, cameFrom: Token)
    func getBottomRight() -> Token
    func getBottomLeft() -> Token
    func solve() -> Int
    func printTopLevel()
}

public struct Day18 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var pair = parse(input.first!)!
        _ = pair.check()
        for i in (1..<input.count) {
            let next = parse(input[i])!
            pair = Pair(left: pair, right: next)
            let result = pair.check()
            print(result, pair)
        }
        return pair.solve()
    }
    
    public func part2(_ input: [String]) -> Int {
        return 0
    }

    public struct Number: Token, CustomStringConvertible {
        public let id = UUID()
        public var parent: Token?
        public let value: Int
        
        public var depth: Int {
            (parent?.depth ?? -1) + 1
        }
        
        public var description: String {
            String(value)
        }
        
        public func addToLeft(_ value: Int, cameFrom: Token) {}
        public func addToRight(_ value: Int, cameFrom: Token) {}
        
        public func getBottomRight() -> Token {
            return self
        }
        
        public func getBottomLeft() -> Token {
            return self
        }
        
        public func printTopLevel() {
            if let parent = parent {
                parent.printTopLevel()
            } else {
                print(description)
            }
        }
        
        public func solve() -> Int {
            return value
        }
    }
    
    public class Pair: Token, CustomStringConvertible {
        public var description: String {
            "[\(left),\(right)]"
        }
        
        public let id = UUID()
        public var parent: Token?
        public var left: Token
        public var right: Token
        public init(parent: Token? = nil, left: Token, right: Token) {
            self.left = left
            self.right = right
            self.left.parent = self
            self.right.parent = self
        }
        
        public var depth: Int {
            (parent?.depth ?? -1) + 1
        }
        
        public func printTopLevel() {
            if let parent = parent {
                parent.printTopLevel()
            } else {
                print(description)
            }
        }
        
        public func solve() -> Int {
            return left.solve() * 3 + right.solve() * 2
        }
        
        public func addToLeft(_ value: Int, cameFrom: Token) {
            if let number = left as? Number {
                let newValue = number.value + value
                if newValue <= 9 {
                    self.left = Number(parent: self, value: newValue)
                } else {
                    let a = newValue / 2
                    let b = newValue - a
                    self.left = Pair(parent: self, left: Number(value: a), right: Number(value: b))
                }
            } else if left.id != cameFrom.id {
                if let number = left.getBottomRight() as? Number, let numberParent = number.parent as? Pair {
                    let newValue = number.value + value
                    if newValue <= 9 {
                        numberParent.right = Number(parent: numberParent, value: newValue)
                    } else {
                        let a = newValue / 2
                        let b = newValue - a
                        numberParent.right = Pair(parent: numberParent, left: Number(value: a), right: Number(value: b))
                        _ = numberParent.check()
                    }
                }
            } else {
                parent?.addToLeft(value, cameFrom: self)
            }
        }
        
        public func getBottomRight() -> Token {
            return right.getBottomRight()
        }
        
        public func getBottomLeft() -> Token {
            return left.getBottomLeft()
        }
        
        public func addToRight(_ value: Int, cameFrom: Token) {
            if let number = right as? Number {
                let newValue = number.value + value
                if newValue <= 9 {
                    self.right = Number(parent: self, value: newValue)
                } else {
                    let a = newValue / 2
                    let b = newValue - a
                    self.right = Pair(parent: self, left: Number(value: a), right: Number(value: b))
                }
            } else if right.id != cameFrom.id {
                if let number = right.getBottomLeft() as? Number, let numberParent = number.parent as? Pair {
                    let newValue = number.value + value
                    if newValue <= 9 {
                        numberParent.left = Number(parent: numberParent, value: newValue)
                    } else {
                        let a = newValue / 2
                        let b = newValue - a
                        numberParent.left = Pair(parent: numberParent, left: Number(value: a), right: Number(value: b))
                    }
                }
            } else {
                parent?.addToRight(value, cameFrom: self)
            }
        }

        public func check(depth: Int = 0) -> Bool {
            if let left = left as? Number, let right = right as? Number {
                print(self.depth, "\(self.description)")
                printTopLevel()
                if depth >= 4 {
                    return false
                }
                if left.value > 9 {
                    let a = left.value / 2
                    let b = left.value - a
                    self.left = Pair(parent: self, left: Number(value: a), right: Number(value: b))
                    return check(depth: depth)
                } else if right.value > 9 {
                    let a = right.value / 2
                    let b = right.value - a
                    self.right = Pair(parent: self, left: Number(value: a), right: Number(value: b))
                    return check(depth: depth)
                }
                return true
            }
            
            let leftPair = left as? Pair
            let rightPair = right as? Pair
            
            if leftPair != nil && rightPair != nil {
                print(self.depth, "\(self.description)")
                printTopLevel()
                let leftCheck = leftPair!.check(depth: depth + 1)
                if !leftCheck {
                    left = Number(parent: self, value: 0)
                    let leftNumber = (leftPair!.left as! Number).value
                    let rightNumber = (leftPair!.right as! Number).value
                    parent?.addToLeft(leftNumber, cameFrom: self)
                    addToRight(rightNumber, cameFrom: self)
                    return check(depth: depth)
                }
                let rightCheck = rightPair!.check(depth: depth + 1)
                if !rightCheck {
                    right = Number(parent: self, value: 0)
                    let leftNumber = (rightPair!.left as! Number).value
                    let rightNumber = (rightPair!.right as! Number).value
                    addToLeft(leftNumber, cameFrom: self)
                    parent?.addToRight(rightNumber, cameFrom: self)
                    return check(depth: depth)
                }
                return leftCheck && rightCheck
            } else if leftPair != nil, let right = right as? Number {
                print(self.depth, "\(self.description)")
                printTopLevel()
                let leftCheck = leftPair!.check(depth: depth + 1)
                if !leftCheck {
                    let newValue = (leftPair!.right as! Number).value + right.value
                    self.left = Number(parent: self, value: 0)
                    if let number = leftPair!.left as? Number {
                        parent?.addToLeft(number.value, cameFrom: self)
                    }
                    if newValue <= 9 {
                        self.right = Number(parent: self, value: newValue)
                    } else {
                        let a = newValue / 2
                        let b = newValue - a
                        self.right = Pair(parent: self, left: Number(value: a), right: Number(value: b))
                    }
                    return check(depth: depth)
                }
                return leftCheck
            } else if rightPair != nil, let left = left as? Number {
                print(self.depth, "\(self.description)")
                printTopLevel()
                let rightCheck = rightPair!.check(depth: depth + 1)
                if !rightCheck {
                    let newValue = (rightPair!.left as! Number).value + left.value
                    self.right = Number(parent: self, value: 0)
                    if let number = rightPair!.right as? Number {
                        parent?.addToRight(number.value, cameFrom: self)
                    }
                    if newValue <= 9 {
                        self.left = Number(parent: self, value: newValue)
                    } else {
                        let a = newValue / 2
                        let b = newValue - a
                        self.left = Pair(parent: self, left: Number(value: a), right: Number(value: b))
                    }
                    return check(depth: depth)
                }
                return rightCheck
            }
            return depth < 4
        }
    }
    
    public enum BasicToken {
        case leftBracket
        case rightBracket
        case number(Int)
    }
    
    public func solve(_ input: String) -> Int {
        if let pair = parse(input) {
            _ = pair.check()
            return pair.solve()
        }
        return -1
    }
    
    public func parse(_ input: String) -> Pair? {
        var basicTokens = [BasicToken]()
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
                        basicTokens.append(.number(value))
                        i = n - 1
                        break
                    }
                    string.append(String(input[n]))
                }
            }
            
            
            i += 1
        }
        
        // convert basic tokens to recursive pairs
        return fetchToken(&basicTokens) as? Pair
    }
    
    public func fetchPair(_ stack: inout [BasicToken]) -> Pair {
        let left = fetchToken(&stack)
        let right = fetchToken(&stack)
        return Pair(left: left, right: right)
    }
    
    public func fetchToken(_ stack: inout [BasicToken]) -> Token {
        while !stack.isEmpty {
            let next = stack.removeFirst()
            switch next {
            case .leftBracket: return fetchPair(&stack)
            case .rightBracket: break
            case .number(let value): return Number(value: value)
            }
        }
        abort()
    }
}
