import Foundation

public class Bundler {
    public static let bundle = Bundle(for: Bundler.self)
}

public enum InputErrors: Error {
    case invalidFilename
    case invalidFileData
}

public struct Input {
    public let input: String
    public init(_ filename: String, with withExtension: String? = nil, _ bundle: Bundle = Bundler.bundle, trimming: Bool = true) {
        let url = bundle.url(forResource: filename, withExtension: withExtension)!
        if trimming {
            input = try! String(contentsOf: url).trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            input = try! String(contentsOf: url)
        }
    }
    
    public init(_ input: String) {
        self.input = input
    }
    
    public var lines: [String] {
        input.lines
    }
    
    public var integers: [Int] {
        lines.compactMap(Int.init)
    }
    
    public func delimited<T>(_ delimiter: Character, cast: (String) -> T) -> [T] {
        return input.split(separator: delimiter).compactMap { cast(String($0)) }
    }
}

public extension String {
    var lines: [String] {
        components(separatedBy: .newlines)
    }
}

public func readInputAsStrings(filename: String, delimiter: Character = "\n", bundle: Bundle = Bundler.bundle) throws -> [String] {
    let url = bundle.url(forResource: filename, withExtension: nil)!
    let value = try String(contentsOf: url).trimmingCharacters(in: .whitespacesAndNewlines)
    return value.split(separator: delimiter).compactMap { String($0) }
}

public func readInputAsIntegers(filename: String, delimiter: Character = "\n", bundle: Bundle = Bundler.bundle) throws -> [Int] {
    let url = bundle.url(forResource: filename, withExtension: nil)!
    let value = try String(contentsOf: url).trimmingCharacters(in: .whitespacesAndNewlines)
    return value.split(separator: delimiter).compactMap { Int(String($0)) }
}
