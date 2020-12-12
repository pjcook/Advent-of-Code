import Foundation

public struct Day4 {
    public init() {}
    
    public func validate(
        input: [String],
        requiredFields: [String] = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"],
        validate: ([String: String], [String]) -> Bool
    ) -> Int {
        var lines = input
        var dict = [String: String]()
        var passports = 0
        
        while !lines.isEmpty {
            let line = lines.removeFirst()
            if line.isEmpty {
                if validate(dict, requiredFields) {
                    passports += 1
                }
                dict = [:]
            } else {
                line
                    .split(separator: " ")
                    .forEach {
                        let components = $0.split(separator: ":")
                        dict[String(components[0])] = String(components[1])
                    }
            }
        }
        
        if !dict.isEmpty {
            if validate(dict, requiredFields) {
                passports += 1
            }
        }
        
        return passports
    }
    
    public static func validateBasic(_ dict: [String:String], _ requiredFields: [String]) -> Bool {
        guard  dict.count >= requiredFields.count else { return false }
        for field in requiredFields {
            if dict[field] == nil {
                return false
            }
        }
        return true
    }
    
    public static func validate(_ dict: [String:String], _ requiredFields: [String]) -> Bool {
        guard  dict.count >= requiredFields.count else { return false }
        for field in requiredFields {
            if dict[field] == nil {
                return false
            } else if let value = dict[field], !validate(field: field, value: value) {
                return false
            }
        }
        return true
    }
    
    public static func validate(field: String, value: String) -> Bool {
        switch field {
        case "byr":
            if let intValue = Int(value) {
                return (1920...2002).contains(intValue)
            }
            
        case "iyr":
            if let intValue = Int(value) {
                return (2010...2020).contains(intValue)
            }
            
        case "eyr":
            if let intValue = Int(value) {
                return (2020...2030).contains(intValue)
            }
            
        case "hgt":
            if value.hasSuffix("in") {
                guard let value = Int(value.replacingOccurrences(of: "in", with: "")) else { return false }
                return (59...76).contains(value)
            } else if value.hasSuffix("cm") {
                guard let value = Int(value.replacingOccurrences(of: "cm", with: "")) else { return false }
                return (150...193).contains(value)
            }
            
        case "hcl":
            guard value.hasPrefix("#") else { return false }
            var value = value
            _ = value.removeFirst()
            guard value.count == 6 else { return false }
            for c in value.lowercased() {
                if !["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "a", "b", "c", "d", "e", "f"].contains(c) {
                    return false
                }
            }
            return true
            
        case "ecl":
            return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(value)
            
        case "pid":
            if value.count == 9, Int(value) != nil {
                return true
            }

        default:
            break
        }

        return false
    }
}
