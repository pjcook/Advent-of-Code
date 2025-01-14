import Foundation

public struct RegularExpression {

    private let expression: NSRegularExpression

    public init(_ pattern: Pattern) throws {
        try self.init(pattern: pattern)
    }
    
    public init(pattern: Pattern) throws {
        expression = try NSRegularExpression(pattern: pattern.rawValue, options: [])
    }

    public func match(_ string: String) throws -> Match {
        let range = NSRange(location: 0, length: string.utf16.count)
        guard
            let result = expression.firstMatch(in: string, options: [], range: range)
        else {
            throw NoMatch(input: string)
        }
        return Match(string: string, result: result)
    }

    public func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return expression.firstMatch(in: string, options: [], range: range) != nil
    }

    public func matches(in string: String) -> [Match] {
        let range = NSRange(location: 0, length: string.utf16.count)
        return expression
            .matches(in: string, options: [], range: range)
            .map { Match(string: string, result: $0) }
    }
}

// MARK: - Errors
extension RegularExpression {
    struct NoMatch: Error { let input: String }
    struct OutOfBounds: Error {}
    struct NotAnInteger: Error {}
}

// MARK: - Pattern
extension RegularExpression {

    public struct Pattern {
        fileprivate let rawValue: String
        public init(_ pattern: String) { rawValue = pattern }
    }
}

extension RegularExpression.Pattern: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

// MARK: - Capture Group
extension RegularExpression {

    public struct CaptureGroup {
        public let string: String
        public let range: Range<String.Index>
    }
}

extension RegularExpression.CaptureGroup: CustomStringConvertible {
    public var description: String { String(string[range]) }
}

// MARK: - Match
extension RegularExpression {

    public struct Match {
        public let string: String
        public let range: Range<String.Index>
        public let captureGroups: [CaptureGroup]
    }
}

extension RegularExpression.Match {

    fileprivate init(string: String, result: NSTextCheckingResult) {
        self.string = string
        range = Range(result.range, in: string)!
        captureGroups = (1..<result.numberOfRanges)
            .map { result.range(at: $0) }
            .compactMap { Range($0, in: string) }
            .map { RegularExpression.CaptureGroup(string: string, range: $0) }
    }
}

extension RegularExpression.Match {

    public func string(at index: Int) throws -> String {
        guard index >= 0 && index < captureGroups.count else {
            throw RegularExpression.OutOfBounds()
        }
        return captureGroups[index].description
    }

    public func integer(at index: Int) throws -> Int {
        guard let integer = try Int(string(at: index)) else {
            throw RegularExpression.NotAnInteger()
        }
        return integer
    }

    public func character(at index: Int) throws -> Character {
        try Character(string(at: index))
    }
}
