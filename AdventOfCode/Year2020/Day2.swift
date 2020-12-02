import Foundation

public struct Day2 {
    public struct PasswordItem {
        let min: Int
        let max: Int
        let test: Character
        let password: String
        
        public init?(_ input: String) {
            guard !input.isEmpty else { return nil }
            let components = input.split(separator: " ")
            let range = components[0].split(separator: "-")
            min = Int(range[0])!
            max = Int(range[1])!
            test = Character(components[1].replacingOccurrences(of: ":", with: ""))
            password = String(components[2])
        }
    }
    
    public func validate(_ item: PasswordItem) -> Bool {
        var count = 0
        for c in item.password {
            if c == item.test { count += 1 }
        }
        return (item.min...item.max).contains(count)
    }
    
    public func validate2(_ item: PasswordItem) -> Bool {
        return
            validate(char: item.test, at: item.min-1, input: item.password) !=
            validate(char: item.test, at: item.max-1, input: item.password)
    }
    
    private func validate(char: Character, at: Int, input: String) -> Bool {
        guard input.count > at else { return false }
        var input = input
        return input.remove(at: input.index(input.startIndex, offsetBy: at)) == char
    }
}
