import Foundation

public struct Day4 {
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
 
public struct Day4_v2 {
    public static var regexes: [NSRegularExpression] { [
        Day4_v2.pidRegex,
        Day4_v2.byrRegex,
        Day4_v2.iyrRegex,
        Day4_v2.hgtRegex,
        Day4_v2.hclRegex,
        Day4_v2.eclRegex,
        Day4_v2.eyrRegex,
        ]
    }

    public static let pidRegex = try! NSRegularExpression(pattern: "(\\bpid:[0-9]{9}\\b){1}", options: .caseInsensitive)
    public static let byrRegex = try! NSRegularExpression(pattern: "(\\bbyr:(19[2-9][0-9]|199[0-9]|200[0-2])){1}", options: .caseInsensitive)
    public static let iyrRegex = try! NSRegularExpression(pattern: "(\\biyr:(201[0-9]|2020)){1}", options: .caseInsensitive)
    public static let hgtRegex = try! NSRegularExpression(pattern: "(\\bhgt:((59|6[0-9]|7[0-6])in|(1[5-8][0-9]|19[0-3])cm)){1}", options: .caseInsensitive)
    public static let hclRegex = try! NSRegularExpression(pattern: "(\\bhcl:#[0-9a-f]{6}){1}", options: .caseInsensitive)
    public static let eclRegex = try! NSRegularExpression(pattern: "(\\becl:(amb|blu|brn|gry|grn|hzl|oth)){1}", options: .caseInsensitive)
    public static let eyrRegex = try! NSRegularExpression(pattern: "(\\beyr:(202[0-9]|2030)){1}", options: .caseInsensitive)

    public static let masterRegex = try! NSRegularExpression(pattern: "((\\bpid:[0-9]{9}\\b){1}|(\\bbyr:(19[2-9][0-9]|199[0-9]|200[0-2])){1}|(\\biyr:(201[0-9]|2020)){1}|(\\bhgt:((59|6[0-9]|7[0-6])in|(1[5-8][0-9]|19[0-3])cm)){1}|(\\bhcl:#[0-9a-f]{6}){1}|(\\becl:(amb|blu|brn|gry|grn|hzl|oth)){1}|(\\beyr:(202[0-9]|2030)){1})", options: .caseInsensitive)

    public func validate2(input: [String]) -> Int {
        var lines = input
        var passports = 0
        var passport = ""
        
        while !lines.isEmpty {
            let line = lines.removeFirst()
            if line.isEmpty {
                passports += validatePassport(passport: passport) ? 1 : 0
                passport = ""
            } else {
                passport += " " + line
            }
        }
        
        if !passport.isEmpty {
            passports += validatePassport(passport: passport) ? 1 : 0
        }
        
        return passports
    }
    
    public func validate3(input: [String], regexes: [NSRegularExpression]) -> Int {
        var lines = input
        var passports = 0
        var passport = ""
        
        while !lines.isEmpty {
            let line = lines.removeFirst()
            if line.isEmpty {
                passports += validatePassport2(passport: passport, regexes: regexes) ? 1 : 0
                passport = ""
            } else {
                passport += " " + line
            }
        }
        
        if !passport.isEmpty {
            passports += validatePassport2(passport: passport, regexes: regexes) ? 1 : 0
        }
        
        return passports
    }
    
    public func validate4(input: [String], regex: NSRegularExpression) -> Int {
        var lines = input
        var passports = 0
        var passport = ""
        
        while !lines.isEmpty {
            let line = lines.removeFirst()
            if line.isEmpty {
                passports += validatePassport3(passport: passport, regex: regex) ? 1 : 0
                passport = ""
            } else {
                passport += " " + line
            }
        }
        
        if !passport.isEmpty {
            passports += validatePassport3(passport: passport, regex: regex) ? 1 : 0
        }
        
        return passports
    }
    
    public func validatePassport(passport: String) -> Bool {
        let requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        let passport = passport.trimmingCharacters(in: .whitespacesAndNewlines)
        var dict = [String: String]()
        passport
            .split(separator: " ")
            .forEach {
                let components = $0.split(separator: ":")
                dict[String(components[0])] = String(components[1])
            }
        return Day4.validate(dict, requiredFields)
    }
    
    public func validatePassport2(passport: String, regexes: [NSRegularExpression]) -> Bool {
        let range = NSRange(location: 0, length: passport.utf16.count)
        for regex in regexes {
            if regex.firstMatch(in: passport, options: [], range: range) == nil {
                return false
            }
        }
        return true
    }
    
    public func validatePassport3(passport: String, regex: NSRegularExpression) -> Bool {
        let range = NSRange(location: 0, length: passport.utf16.count)
        let results = regex.matches(in: passport, options: [], range: range)
        return results.count == 7
    }
}
