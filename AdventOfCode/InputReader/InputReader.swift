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
    public init(_ filename: String, _ bundle: Bundle = Bundler.bundle) throws {
        guard let url = bundle.url(forResource: filename, withExtension: nil) else {
            throw InputErrors.invalidFilename
        }
        input = try String(contentsOf: url).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var lines: [String] {
        input.lines
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

public func readInput<T>(filename: String, delimiter: Character, cast: (String) -> T, bundle: Bundle = Bundler.bundle) throws -> [T] {
    func cleanString(_ input: String) -> String {
        return input.replacingOccurrences(of: "\n", with: "")
    }
    
    guard let url = bundle.url(forResource: filename, withExtension: nil) else {
        throw InputErrors.invalidFilename
    }
    let value = try String(contentsOf: url)
    return value.split(separator: delimiter).compactMap { cast(cleanString(String($0))) }
}
